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
    # home.file.s3air-config = {
    #   source = ../../../files/sonic3air/settings.json;
    #   target = ".config/Sonic3AIR/settings.json";
    # };

    xdg = {
      desktopEntries = {
        sonic3air = {
          name = "Sonic 3: Angel Island Revisited";
          genericName = "Sonic Fan Remaster of Sonic 3 & Knuckles";
          type = "Application";
          exec = "steam-run /mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux";
          terminal = false;
          categories = [ "Game" ];
          icon = "/mnt/games/Sonic\\ 3:\\ Angel\\ Island\\ Revisited/sonic3air_linux/data/icon.png";
        };
      };
      configFile."Sonic3AIR/settings.json".source = ./files/settings.json;
    };
  };
}