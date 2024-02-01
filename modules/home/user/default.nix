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
      cache = mkOpt types.str "${cfg.directories.home}/.cache" "Cache directory.";
      config = mkOpt types.str "${cfg.directories.home}/.config" "Application configurations.";
      data = mkOpt types.str "${cfg.directories.home}/.local/share" "Application data.";
      desktop = mkOpt types.str "${cfg.directories.home}/Desktop" "Desktop directory.";
      documents = mkOpt types.str "${cfg.directories.home}/Documents" "Documents directory.";
      downloads = mkOpt types.str "${cfg.directories.home}/Downloads" "Downloads directory.";
      games = mkOpt types.str "${cfg.directories.home}/Games" "Games! :D";
      home = mkOpt types.str home-directory "My home directory!";
      pictures = mkOpt types.str "${cfg.directories.home}/Pictures" "Pictures directory.";
      music = mkOpt types.str "${cfg.directories.home}/Music" "Music directory.";
      screenshots = mkOpt types.str "${cfg.directories.pictures}/Screenshots" "Screenshots directory.";
      share = mkOpt types.str "${cfg.directories.home}/Public" "Public share directory.";
      state = mkOpt types.str "${cfg.directories.home}/.local/state" "State applicationd data directory.";
      templates = mkOpt types.str "${cfg.directories.home}/Templates" "Templates directory.";
      videos = mkOpt types.str "${cfg.directories.home}/Videos" "Videos directory.";
      wallpapers = mkOpt types.str "${cfg.directories.pictures}/Wallpapers" "Location of images for graphical backdrops.";
    };
    icon = mkOpt types.path "${cfg.directories.home}/.face" "My profile pic!";
    bell = mkOpt types.path "${cfg.directories.data}/sound/bell.oga" "My bell sound!";
  };

  config = mkIf cfg.enable {
    home = {
      username = "yaro";
      homeDirectory = cfg.directories.home;
      file = {
        pfp = {
          source = ./files/techkat.png;
          target = cfg.icon;
        };
        bell = {
          source = ./files/bell.oga;
          target = cfg.bell;
        };
        "${cfg.directories.pictures}/techkat.png".source = ./files/techkat.png;
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

    xdg = {
      cacheHome = cfg.directories.cache;
      configHome = cfg.directories.config;
      dataHome = cfg.directories.data;
      stateHome = cfg.directories.state;
      userDirs = mkIf config.united.desktop.enable {
        enable = true;
        createDirectories = false;
        desktop = cfg.directories.desktop;
        documents = cfg.directories.documents;
        download = cfg.directories.downloads;
        music = cfg.directories.music;
        pictures = cfg.directories.pictures;
        publicShare = cfg.directories.share;
        templates = cfg.directories.templates;
        videos = cfg.directories.videos;
      };
    };
  };
}
