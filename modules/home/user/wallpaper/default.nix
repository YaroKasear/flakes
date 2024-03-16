{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.user.wallpaper;
in {
  options.united.user.wallpaper = {
    enable = mkEnableOption "User wallpapers!";
    defaultWallpaper = mkOpt types.path ./files/maze.png "Set the default wallpaper!";
  };

  config = mkIf cfg.enable {
    home.file = {
      "${config.united.user.directories.wallpapers}" = {
        source = ./files;
        recursive = true;
      };
    };
  };
}