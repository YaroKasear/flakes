{ lib, config, pkgs, inputs, ... }:

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
      script = "echo 'I refuse to start as a systemd service since I launch before i3 is ready this way.'";
      settings = let
        fonts = [
          "${config.united.style.fonts.interface}:style=Regular:size=10;2"
          "${config.united.style.fonts.emoji}:scale=10;2:style=Regular"
        ];
      in with config.united.style; {
        "global/wm" = {
          margin-top = 5;
          margin-bottom = 5;
        };
        "bar/top" = {
          bottom = false;
          enable-ipc = true;
          fixed-center = true;
          height = 30;
          font = fonts;
          dpi = 0;
          modules-left = "space xwindow";
          modules-right = "player-mpris-tail space";
          pseudo-transparency = true;
          background = colors.background;
          foreground = colors.foreground;
        };
        "bar/bottom" = {
          bottom = true;
          enable-ipc = true;
          fixed-center = true;
          height = 30;
          font = fonts;
          dpi = 0;
          modules-left = "i3";
          modules-right = "pulseaudio tray date";
          pseudo-transparency = true;
          background = colors.background;
          foreground = colors.foreground;
          margin-bottom = 5;
        };
        "module/i3" = {
          type = "internal/i3";
          label-focused = "%index%";
          label-unfocused = "%index%";
          label-urgent = "%index%";
          label-visible = "%index%";
          label-focused-overline = colors.active_border_color;
          label-focused-background = colors.active_tab_background;
          label-focused-foreground = colors.active_tab_foreground;
          label-focused-padding = 2;
          label-unfocused-padding = 2;
          label-urgent-background = colors.red;
          label-urgent-padding = 2;
          label-visible-padding = 2;
        };
        "module/tray" = {
          type = "internal/tray";
          tray-background = colors.background;
          tray-foreground = colors.foreground;
        };
        "module/date" = {
          type = "internal/date";
          date = "%B %e, %Y";
          time = "%r";
          label = " %date% %time% ";
        };
        "module/space" = {
          type = "custom/text";
          label = " ";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          interval = 5;
          format-volume = "<label-volume> <ramp-volume> <bar-volume> ";
          format-muted = "<ramp-volume> <bar-volume> ";
          format-muted-prefix = "🔇 ";
          bar-volume-width = 10;
          bar-volume-indicator = "|";
          bar-volume-indicator-foreground = colors.foreground;
          bar-volume-fill = "─";
          bar-volume-empty = "─";
          bar-volume-empty-foreground = colors.inactive_border_color;
          ramp-volume = [
            "🔈"
            "🔉"
            "🔊"
          ];
          use-ui-volume = true;
        };
        "module/player-mpris-tail" = {
          type = "custom/script";
          exec = "${config.united.user.directories.config}/polybar/player-mpris-tail.py -f '{artist} - {title}'";
          tail = true;
        };
        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title%";
        };
      };
    };

    xdg.configFile = {
      player-mpris-tail = {
        executable = true;
        source = "${inputs.polybar-scripts}/polybar-scripts/player-mpris-tail/player-mpris-tail.py";
        target = "polybar/player-mpris-tail.py";
      };
    };
  };
}