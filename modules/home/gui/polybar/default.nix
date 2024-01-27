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
          "FiraCode Nerd Font:style=Regular:size=10;2"
          "Noto Color Emoji:scale=10;2:style=Regular"
        ];
      in {
        "colors" = config.united.style;
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
          background = [
            "\${colors.tertiary}"
            "\${colors.secondary}"
            "\${colors.tertiary}"
          ];
          foreground = "\${colors.primary}";
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
          background = [
            "\${colors.tertiary}"
            "\${colors.secondary}"
            "\${colors.tertiary}"
          ];
          foreground = "\${colors.primary}";
          margin-bottom = 5;
        };
        "module/i3" = {
          type = "internal/i3";
          label-focused = "%index%";
          label-unfocused = "%index%";
          label-urgent = "%index%";
          label-visible = "%index%";
          label-focused-overline = "\${colors.primary}";
          label-focused-background = "\${colors.primary}";
          label-focused-foreground = "\${colors.secondary}";
          label-focused-padding = 2;
          label-unfocused-padding = 2;
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 2;
          label-visible-padding = 2;
        };
        "module/tray" = {
          type = "internal/tray";
          tray-background = "\${colors.secondary}";
          tray-foreground = "\${colors.primary}";
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
          bar-volume-indicator-foreground = "\${colors.alert}";
          bar-volume-fill = "─";
          bar-volume-empty = "─";
          bar-volume-empty-foreground = "\${colors.tertiary}";
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

    # home.file = {
    #   player-mpris-tail = {
    #     executable = true;
    #     source = ../../../files/polybar/player-mpris-tail.py;
    #     target = ".config/polybar/player-mpris-tail.py";
    #   };
    # };

    xdg.configFile."polybar/player-mpris-tail.py".source = inputs.player-mpris-tail;
  };
}