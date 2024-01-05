{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (config.united) user;
  cfg = config.united.am2r;
in
  {
  options.united.am2r = {
    enable = mkEnableOption "Am2r";
  };

  config = mkIf cfg.enable {
    xdg.configFile."AM2R/config.ini".source = ./files/config.ini;

    xdg.desktopEntries.am2r = {
      name = "Another Metroid 2 Remake";
      genericName = "Metroid Fan Remake of Metroid 2: Return of Samus";
      type = "Application";
      exec = "steam-run  /mnt/games/Another\\ Metroid\\ 2\\ Remake/runner";
      terminal = false;
      categories = [ "Game" ];
      icon = "/mnt/games/Another\\ Metroid\\ 2\\ Remake/icon.png";
    };
  };
}