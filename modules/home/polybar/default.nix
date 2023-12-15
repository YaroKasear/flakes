{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.polybar;
in {
  options.united.polybar = {
    enable = mkEnableOption "Polybar";
  };

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        alsaSupport = false;
        pulseSupport = true;
        i3Support = true;
      };
      script = ''
        echo "Not yet."
      '';
      settings = {
        "bar/top" = {
          bottom = false;
          fixed-center = true;
          font = [
            "FiraCode Nerd Font:style=Regular"
            "Noto Color Emoji:scale=10:style=Regular"
          ];
          dpi = 0;
          modules-left = "player-mpris-tail";
          modules-right = "pulseaudio";
          pseudo-transparency = true;
        };
        "bar/bottom" = {
          bottom = true;
          fixed-center = true;
          dpi = 0;
          pseudo-transparency = true;
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          interval = 5;
          format-volume = "<label-volume> <ramp-volume> <bar-volume> ";
          format-muted = "<ramp-volume> <bar-volume> ";
          format-muted-prefix = "🔇 ";
          bar-volume-width = 10;
          bar-volume-indicator = "|";
          bar-volume-fill = "─";
          bar-volume-empty = "─";
          ramp-volume = [
            "🔈"
            "🔉"
            "🔊"
          ];
          use-ui-volume = true;
        };
        "module/player-mpris-tail" = {
          type = "custom/script";
          exec = "~/.config/polybar/player-mpris-tail.py -f '{artist} - {title}'";
          tail = true;
        };
      };
    };

    home.file = {
      player-mpris-tail = {
        executable = true;
        source = ../../../files/polybar/player-mpris-tail.py;
        target = ".config/polybar/player-mpris-tail.py";
      };
    };
  };
}