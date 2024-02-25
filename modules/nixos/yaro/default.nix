{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.yaro;
in {
  options.united.yaro = rec {
    enable = mkEnableOption "Yaro";
  };

  config = mkIf cfg.enable {
    users = {
      users.yaro = {
        isNormalUser = true;
        extraGroups = ["wheel" "video" "audio" "networkmanager" "lp" "gamemode" "systemd-journal"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets.hashedpw.path;
      };
    };

    sops = {
      secrets = {
        authfile = {
          path = "/home/yaro/.config/Yubico/u2f_keys";
          mode = "0440";
          owner = config.users.users.yaro.name;
          group = config.users.users.yaro.group;
          sopsFile = ./secrets.yaml;
        };
        hashedpw = {
          neededForUsers = true;
          sopsFile = ./secrets.yaml;
        };
      };
    };

    systemd = {
      tmpfiles.settings = {
        "10-fix-dotconfig" = {
          "/home/yaro/.config" = {
            d = {
              user = "yaro";
              group = "users";
              mode = "0755";
            };
          };
          "/home/yaro/.config/Yubico" = {
            d = {
              user = "yaro";
              group = "users";
              mode = "0755";
            };
          };
        };
      };
    };
  };
}