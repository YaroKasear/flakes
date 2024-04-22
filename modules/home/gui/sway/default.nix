{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.sway;
in {
  options.united.sway = {
    enable = mkEnableOption "Sway";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      swaynag.enable = true;
      config = {
        menu = "wofi --show drun";
        output = {
          DP-3 = {
            mode = "2560x1440@144Hz";
          };
        };
      };
    };

    programs.wofi.enable = true;

    home = {
      packages = with pkgs; [
        grim
        libva
        slurp
        swaynotificationcenter
        wl-clipboard
        xwaylandvideobridge
      ];
    };
  };
}