{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.sonic3air;
in
{
  options.united.sonic3air = {
    enable = mkEnableOption "Sonic3air";
    ROM = mkOpt types.str null "Where the Sonic3K ROM is found.";
  };

  config = mkIf cfg.enable {

    xdg = {
      desktopEntries = {
        sonic3air = {
          name = "Sonic 3: Angel Island Revisited";
          genericName = "Sonic Fan Remaster of Sonic 3 & Knuckles";
          type = "Application";
          exec = "steam-run gamemoderun ${config.united.user.directories.games}/sonic3air/sonic3air_linux";
          terminal = false;
          categories = [ "Game" ];
          icon = "${config.united.user.directories.games}/sonic3air/sonic3air_linux/data/icon.png";
        };
      };
      dataFile = {
        "Sonic3AIR/Sonic_Knuckles_wSonic3.bin".source = config.lib.file.mkOutOfStoreSymlink cfg.ROM;
        "Sonic3AIR/settings.json".source = ./files/settings.json;
        "Sonic3AIR/mods/active-mods.json".text = builtins.toJSON {
          ActiveMods = [
            "yaromusicmod"
          ];
          UseLegacyLoading = false;
        };
        "Sonic3AIR/mods/yaromusicmod" = {
          source = config.lib.file.mkOutOfStoreSymlink "/mnt/music/Sonic the Hedgehog/Sonic 3 AIR Yaro Music Mod/";
          recursive = true;
        };
      };
    };
  };
}
