{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.steam;
in {
  options.united.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protontricks
      steam-run
    ];

    programs = {
      steam = {
        enable = true;
        extraCompatPackages = mkIf cfg.enable [
          pkgs.proton-ge-bin
        ];
      };
      gamemode = {
        enable = true;
        settings = {
          general = {
            defaultgov = "powersave";
            desiredgov = "performance";
            inhibit_screensaver = 0;
            ioprio = 0;
            reaper_freq = 5;
            renice = 10;
            softrealtime = "auto";
          };
        };
      };
    };
  };
}
