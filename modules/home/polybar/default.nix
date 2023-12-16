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
        polybar top &
        polybar bottom &
      '';
      settings = {
        "bar/top" = {
          bottom = false;
          enable-ipc = true;
          fixed-center = true;
          height = 30;
          font = [
            "FiraCode Nerd Font:style=Regular"
            "Noto Color Emoji:scale=10:style=Regular"
          ];
          dpi = 0;
          modules-left = "xwindow";
          modules-right = "player-mpris-tail";
          pseudo-transparency = true;
        };
        "bar/bottom" = {
          bottom = true;
          enable-ipc = true;
          fixed-center = true;
          height = 30;
          font = [
            "FiraCode Nerd Font:style=Regular"
            "Noto Color Emoji:scale=10:style=Regular"
          ];
          dpi = 0;
          modules-left = "i3";
          modules-right = "pulseaudio tray date";
          pseudo-transparency = true;
        };
        "module/i3" = {
          type = "internal/i3";
        };
        "module/tray" = {
          type = "internal/tray";
        };
        "module/date" = {
          type = "internal/date";
          date = "%B %e, %Y";
          time = "%r";
          label = " %date% %time%";
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
        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title%";
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