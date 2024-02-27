{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.cnelson;
in {
  options.united.cnelson = rec {
    enable = mkEnableOption "cnelson";
  };

  config = mkIf cfg.enable {
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
  };
}