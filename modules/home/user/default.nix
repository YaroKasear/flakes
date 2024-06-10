{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  home-directory =
    if is-darwin then
      "/Users"
    else
      "/home";

  cfg = config.united.user;
in {
  options.united.user = {
    enable = mkEnableOption "User";

    name = mkOpt types.str "yaro" "My user name!";
    fullName = mkOpt types.str "Yaro Kasear" "My full name!";
    directories = {
      cache = mkOpt types.str "${cfg.directories.home}/.cache" "Cache directory.";
      config = mkOpt types.str "${cfg.directories.home}/.config" "Application configurations.";
      data = mkOpt types.str "${cfg.directories.home}/.local/share" "Application data.";
      desktop = mkOpt types.str "${cfg.directories.home}/Desktop" "Desktop directory.";
      documents = mkOpt types.str "${cfg.directories.home}/Documents" "Documents directory.";
      downloads = mkOpt types.str "${cfg.directories.home}/Downloads" "Downloads directory.";
      games = mkOpt types.str "${cfg.directories.home}/Games" "Games! :D";
      home = mkOpt types.str "${home-directory}/${cfg.name}" "My home directory!";
      pictures = mkOpt types.str "${cfg.directories.home}/Pictures" "Pictures directory.";
      music = mkOpt types.str "${cfg.directories.home}/Music" "Music directory.";
      screenshots = mkOpt types.str "${cfg.directories.pictures}/Screenshots" "Screenshots directory.";
      share = mkOpt types.str "${cfg.directories.home}/Public" "Public share directory.";
      state = mkOpt types.str "${cfg.directories.home}/.local/state" "State applicationd data directory.";
      templates = mkOpt types.str "${cfg.directories.home}/Templates" "Templates directory.";
      videos = mkOpt types.str "${cfg.directories.home}/Videos" "Videos directory.";
      wallpapers = mkOpt types.str "${cfg.directories.pictures}/Wallpapers" "Location of images for graphical backdrops.";
    };
    icon = mkOpt types.path ./files/pfp.png "My profile pic!";
    bell = mkOpt types.path ./files/bell.oga "My bell sound!";
  };

  config = mkIf cfg.enable {
    home = {
      username = mkDefault "yaro";
      homeDirectory = mkDefault cfg.directories.home;
      file = {
        pfp = mkIf (cfg.icon != null) {
          source = cfg.icon;
          target = "${cfg.directories.home}/.face";
        };
        bell = mkIf (cfg.icon != null) {
          source = cfg.bell;
          target = "${cfg.directories.data}/sound/bell.oga";
        };
      };
    };

    sops.secrets = mkIf config.united.sops.enable {
      mosquitto-password.sopsFile = ./secrets.yaml;
    };

    xdg = mkIf is-linux {
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
