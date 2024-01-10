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
      steamtinkerlaunch
      unixtools.xxd
      xdotool
      xorg.xprop
      xorg.xwininfo
      yad
    ];

    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [
          inputs.nix-gaming.packages.${pkgs.system}.proton-ge
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
