{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.user.wallpaper;
in {
  options.united.user.wallpaper = {
    enable = mkEnableOption "User wallpapers!";
  };

  config = mkIf cfg.enable {
    home.file."Pictures/Wallpaper" = {
      source = ./files;
      recursive = true;
    };
  };
}