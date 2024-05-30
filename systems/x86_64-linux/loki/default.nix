{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
    };
    secrets.hashed-password.rekeyFile = secrets-directory + "hashed-password.age";
  };

  united = {
    loki.enable = true;
    desktop = {
      enable = true;
      use-wayland = true;
    };
    wayland.compositor = "plasma";
  };

  users.users = {
    cnelson = {
      isNormalUser = true;
      extraGroups = ["video" "audio" "lp"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.hashedpw.path;
    };
    yaro = {
      isNormalUser = true;
      extraGroups = ["wheel" "video" "audio" "networkmanager" "lp" "gamemode" "systemd-journal"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.hashedpw.path;
    };
  };

  sops = {
    secrets = {
      authfile.sopsFile = ./secrets.yaml;
      hashedpw = {
        neededForUsers = true;
        sopsFile = ./secrets.yaml;
      };
      "users_conrad_server".sopsFile = ./secrets.yaml;
    };
  };
}
