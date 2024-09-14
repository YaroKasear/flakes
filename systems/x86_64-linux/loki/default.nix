{ lib, pkgs, inputs, config, ... }:
with lib;
with lib.united;
with config.home-manager.users;

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

in {
  age = {
    identityPaths = ["/persistent/etc/ssh/ssh_host_ed25519_key"];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
    };
    secrets = {
      mosquitto-password = {
        rekeyFile = secrets-directory + "mosquitto-password.age";
        path = "/run/mosquitto-password";
        owner = "yaro";
        mode = "400";
        symlink = false;
      };
      guest-password.rekeyFile = secrets-directory + "guest-password.age";
      "worlds.tf" = {
        rekeyFile = secrets-directory + "worlds.tf.age";
        path = "/run/worlds.tf";
        owner = "yaro";
        mode = "400";
        symlink = false;
      };
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  boot.supportedFilesystems = ["ntfs"];

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = enabled;
  };

  united = {
    loki = enabled;
    common = {
      splash = true;
      banner = ''
        [90;40m░░░░░░░░░░░░░░░░░[0m
        [90;40m░[32m█[90m░░░[32m█▀█[90m░[32m█[90m░[32m█[90m░[32m▀[32m█▀[90m░[0m
        [90;40m░[32m█[90m░░░[32m█[90m░[32m█[90m░[32m█▀[32m▄[90m░░[32m█[90m░░[0m
        [90;40m░[32m▀▀▀[90m░[32m▀▀▀[90m░[32m▀[90m░[32m▀[90m░[32m▀[32m▀▀[90m░[0m
        [90;40m░░░░░░░░░░░░░░░░░[0m
      '';
    };
    desktop = {
      enable = true;
      use-wayland = true;
    };
    wayland.compositor = "plasma";
    web-applications = {
      hostInterface = "enp9s0";
      tlsConfig.readOnly = true;
      services = [
        {
          name = "cnelson";
          dataDir = "/etc/cnelson";
          extraConfig.environment.etc = {
            "cnelson/index.html".source = ./files/cnelson/index.html;
            "cnelson/bootstrap".source = "${pkgs.twitterBootstrap}";
            "cnelson/css".source = ./files/cnelson/css;
            "cnelson/images".source = ./files/cnelson/images;
            "cnelson/js".source = ./files/cnelson/js;
          };
        }
      ];
    };
  };

  systemd.coredump.enable = true;

  users.users = {
    yaro.extraGroups = ["video" "audio" "lp" "gamemode"];
    guest = {
      description = config.home-manager.users.guest.united.user.fullName;
      home = config.home-manager.users.guest.united.user.directories.home;
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPasswordFile = mkDefault config.age.secrets.guest-password.path;
    };
  };
}
