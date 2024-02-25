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
          inputs.nix-gaming.packages.${pkgs.system}.proton-ge
        ];
        gamescopeSession.enable = config.united.wayland.enable;
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
      gamescope = mkIf config.united.wayland.enable {
        enable = true;
        capSysNice = true;
      };
    };
  };
}
