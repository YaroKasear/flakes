{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;
  home-directory =
    if is-darwin then
      "/Users/yaro"
    else
      "/home/yaro";
  cfg = config.united.user;
in {
  options.united.user = {
    enable = mkEnableOption "User";

    name = mkOption {
      type = types.str;
      default = "yaro";
    };
    home-directory = mkOption {
      type = types.str;
      default = home-directory;
    };
    config-directory = mkOption {
      type = types.str;
      default = "${home-directory}/.config";
    };

    colors = {
      primary = mkOption {
        type = types.str;
        default = "#18FFD8";
      };
      secondary = mkOption {
        type = types.str;
        default = "#303060";
      };
      tertiary = mkOption {
        type = types.str;
        default = "#181830";
      };
      window = mkOption {
        type = types.str;
        default = "#189090";
      };
      alert = mkOption {
        type = types.str;
        default = "#FF4848";
      };
      white = mkOption {
        type = types.str;
        default = "#eeffff";
      };
      black = mkOption {
        type = types.str;
        default = "#15121c";
      };
      red = mkOption {
        type = types.str;
        default = "#cb5760";
      };
      green = mkOption {
        type = types.str;
        default = "#999f63";
      };
      yellow = mkOption {
        type = types.str;
        default = "#d4a067";
      };
      blue = mkOption {
        type = types.str;
        default = "#6c90a8";
      };
      purple = mkOption {
        type = types.str;
        default = "#776690";
      };
      cyan = mkOption {
        type = types.str;
        default = "#528a9b";
      };
      pink = mkOption {
        type = types.str;
        default = "#ffa8c5";
      };
      orange = mkOption {
        type = types.str;
        default = "#c87c3e";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      username = "yaro";
      homeDirectory = home-directory;
    };

    accounts.email.accounts = {
      Personal = {
        address = "yarokasear@gmail.com";
        flavor = "gmail.com";
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = true;
        };
        primary = true;
        realName = "Yaro Kasear";
        thunderbird.enable = true;
      };
      Heartbeat = {
        address = "yaro@kasear.net";
        flavor = "gmail.com";
        gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = true;
        };
        realName = "Yaro Kasear";
        thunderbird.enable = true;
      };
      Wanachi = {
        address = "wanachi@tlkmuck.org";
        flavor = "gmail.com";
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = true;
        };
        realName = "Wanachi";
        thunderbird.enable = true;
      };
      Work = {
        address = "cnelson@braunresearch.com";
        flavor = "gmail.com";
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = false;
        };
        realName = "Conrad Nelson";
        thunderbird.enable = true;
        signature.text = sops.secrets."accounts/email/accounts/Work/signature/text";
      };
    };

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      gnupg = {
        home = "/home/yaro/.gnupg";
        sshKeyPaths = [];
      };
      secrets."accounts/email/accounts/Work/signature/text" = { };
    };
  };
}
