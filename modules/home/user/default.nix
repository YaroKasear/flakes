{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

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

    name = mkOpt types.str "yaro" "My user name!";
    directories = {
      home = mkOpt types.str home-directory "My home directory!";
    };
    icon = mkOpt types.path "${home-directory}/.face" "My profile pic!";
    bell = mkOpt types.path "${home-directory}/.local/share/sound/bell.oga" "My bell sound!";
  };

  config = mkIf cfg.enable {
    home = {
      username = "yaro";
      homeDirectory = home-directory;
      file = {
        pfp = {
          source = ./files/techkat.png;
          target = cfg.icon;
        };
        bell = {
          source = ./files/bell.oga;
          target = cfg.bell;
        };
        "Pictures/techkat.png".source = ./files/techkat.png;
      };
    };

    accounts.email.accounts = {
      Personal = {
        address = "yarokasear@gmail.com";
        flavor = "gmail.com";
        primary = true;
        realName = "Yaro Kasear";
        thunderbird.enable = true;
      };
      Heartbeat = {
        address = "yaro@kasear.net";
        flavor = "gmail.com";
        realName = "Yaro Kasear";
        thunderbird.enable = true;
      };
      Wanachi = {
        address = "wanachi@tlkmuck.org";
        flavor = "gmail.com";
        realName = "Wanachi";
        thunderbird.enable = true;
      };
      Work = {
        address = "cnelson@braunresearch.com";
        flavor = "gmail.com";
        realName = "Conrad Nelson";
        thunderbird.enable = true;
      };
    };

    sops.secrets = mkIf config.united.sops.enable {
      mosquitto-password.sopsFile = ./secrets.yaml;
      signature.sopsFile = ./secrets.yaml;
    };
  };
}
