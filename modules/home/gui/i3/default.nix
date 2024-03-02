{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.i3;
in {
  options.united.i3 = {
    enable = mkEnableOption "I3";
  };

  config = mkIf cfg.enable {
    united = {
      autorandr.enable = true;
      kitty.enable = true;
      polybar.enable = true;
      picom.enable = true;
    };

    home = {
      packages = with pkgs; [
        dex
        dunst
        networkmanagerapplet
      ];
    };

    programs = {
      rofi.enable = true;
    };

    xsession = {
      enable = true;
      numlock.enable = true;
      windowManager.i3 = {
        enable = true;
        config = {
          defaultWorkspace = "workspace number 0";
          bars = [ ];
          terminal = "kitty -1";
          modifier = "Mod4";
          menu = "${pkgs.rofi}/bin/rofi -show drun";
          fonts = {
            names = [
              config.united.style.fonts.interface
            ];
          };
          floating = {
            titlebar = true;
            border = 1;
          };
          gaps = {
            inner = 5;
            smartGaps = true;
          };
          colors = with config.united.style.colors; {
            background = background;
            focused = {
              border = active_border_color;
              background = active_tab_background;
              text = active_tab_foreground;
              indicator = active_tab_foreground;
              childBorder = active_border_color;
            };
            focusedInactive = {
              border = active_border_color;
              background = active_tab_background;
              text = active_tab_foreground;
              indicator = active_tab_foreground;
              childBorder = active_border_color;
            };
            unfocused = {
              border = inactive_border_color;
              background = inactive_tab_background;
              text = inactive_tab_foreground;
              indicator = inactive_tab_foreground;
              childBorder = inactive_border_color;
            };
            urgent = {
              border = active_border_color;
              background = red;
              text = active_tab_foreground;
              indicator = active_tab_foreground;
              childBorder = active_border_color;
            };
            placeholder = {
              border = inactive_border_color;
              background = inactive_tab_background;
              text = inactive_tab_foreground;
              indicator = inactive_tab_foreground;
              childBorder = inactive_border_color;
            };
          };
          keybindings = let
            modifier = config.xsession.windowManager.i3.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+Shift+w" = "sticky toggle";
            "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
            "XF86AudioNext" = "exec --no-startup-id playerctl next";
            "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
          };
          startup = [
            { command = "polybar top"; notification = false; }
            { command = "polybar bottom"; notification = false; }
            { command = "dunst"; notification = false; }
          ];
        };
        extraConfig = "for_window [title=\"Picture-in-Picture\"] sticky enable";
      };
    };
  };
}