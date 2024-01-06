{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.sonic3air;
in {
  options.united.sonic3air = {
    enable = mkEnableOption "Sonic3air";
  };

  config = mkIf cfg.enable {
    xdg = {
      desktopEntries = {
        sonic3air = {
          name = "Sonic 3: Angel Island Revisited";
          genericName = "Sonic Fan Remaster of Sonic 3 & Knuckles";
          type = "Application";
          exec = "steam-run gamemoderun /mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux";
          terminal = false;
          categories = [ "Game" ];
          icon = "/mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux/data/icon.png";
        };
      };
      configFile."Sonic3AIR/settings.json".source = ./files/settings.json;
    };
  };
}