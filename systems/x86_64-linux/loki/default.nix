{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    loki.enable = true;
    desktop = {
      enable = true;
      use-wayland = true;
    };
  };

  users = {
    users.cnelson = {
      isNormalUser = true;
      extraGroups = ["video" "audio" "lp"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.hashedpw.path;
    };
  };

  sops = {
    secrets = {
      cnelson-authfile = {
        path = "/home/cnelson/.config/Yubico/u2f_keys";
        mode = "0440";
        owner = config.users.users.cnelson.name;
        group = config.users.users.cnelson.group;
        sopsFile = ./secrets.yaml;
      };
    };
  };

  systemd = {
    tmpfiles.settings = {
      "10-fix-dotconfig" = {
        "/home/cnelson/.config" = {
          d = {
            user = "cnelson";
            group = "users";
            mode = "0755";
          };
        };
        "/home/cnelson/.config/Yubico" = {
          d = {
            user = "cnelson";
            group = "users";
            mode = "0755";
          };
        };
      };
    };
  };
}
