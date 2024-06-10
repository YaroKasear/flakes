{ lib, config, ... }:

with lib;
with lib.united;
let
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
      exec = "steam-run gamemoderun ${config.united.user.directories.games}/Another\\ Metroid\\ 2\\ Remake/runner";
      terminal = false;
      categories = [ "Game" ];
      icon = "${config.united.user.directories.games}/Another\\ Metroid\\ 2\\ Remake/icon.png";
    };
  };
}