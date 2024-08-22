{ lib, pkgs, inputs, config, ... }:
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
      cnelson-password.rekeyFile = secrets-directory + "cnelson-password.age";
      mosquitto-password = {
        rekeyFile = secrets-directory + "mosquitto-password.age";
        path = "/run/mosquitto-password";
        owner = "yaro";
        mode = "400";
        symlink = false;
      };
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = enabled;
  };

  snowfallorg.users.cnelson.admin = false;

  united = {
    loki = enabled;
    common.splash = true;
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
          name = "test";
          backend = "php";
        }
        {
          name = "all";
          serverType = "apache";
        }
      ];
    };
  };

  systemd.coredump.enable = true;

  users = {
    users = {
      yaro.extraGroups = ["video" "audio" "lp" "gamemode"];
      cnelson = {
        description = cnelson.united.user.fullName;
        home = cnelson.united.user.directories.home;
        isNormalUser = true;
        extraGroups = ["video" "audio" "lp"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.age.secrets.cnelson-password.path;
      };
    };
  };
}
