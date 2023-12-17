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
      file = {
        layout = {
          source = ../../../files/i3/layout.json;
          target = ".config/i3/layout.json";
        };
      };

      packages = with pkgs;
      let
        wp-gen = inputs.wallpaper-generator.packages.${system}.wp-gen;
      in [
        dex
        dunst
        networkmanagerapplet
        nitrogen
        playerctl
        wp-gen
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
              "FiraCode Nerd Font"
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
          colors = with config.united.user.colors; {
            background = window;
            focused = {
              border = tertiary;
              background = primary;
              text = tertiary;
              indicator = tertiary;
              childBorder = tertiary;
            };
            focusedInactive = {
              border = tertiary;
              background = secondary;
              text = primary;
              indicator = tertiary;
              childBorder = tertiary;
            };
            unfocused = {
              border = tertiary;
              background = tertiary;
              text = window;
              indicator = tertiary;
              childBorder = tertiary;
            };
            urgent = {
              border = tertiary;
              background = alert;
              text = tertiary;
              indicator = tertiary;
              childBorder = tertiary;
            };
            placeholder = {
              border = tertiary;
              background = tertiary;
              text = primary;
              indicator = tertiary;
              childBorder = tertiary;
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
            { command = "i3-wsman polybar watch"; notification = false; }
            { command = "wallpaper-generator `ls ${inputs.wallpaper-generator.packages.x86_64-linux.wp-gen}/bin/generators | grep .lua | shuf -n 1 | cut -d . -f 1` -o /tmp/background.png --width 2560 --height 1440 && nitrogen --restore"; notification = false; }
            { command = "i3-msg 'workspace 1; append_layout /home/yaro/.config/i3/layout.json'"; notification = false; }
            { command = "firefox"; notification = false; }
            { command = "thunderbird"; notification = false; }
            { command = "hexchat"; notification = false; }
            { command = "discord"; notification = false; }
            { command = "kitty -1"; notification = false; }
            { command = "skypeforlinux"; notification = false; }
            { command = "telegram-desktop"; notification = false; }
            { command = "dunst"; notification = false; }
          ];
        };
        extraConfig = "for_window [title=\"Picture-in-Picture\"] sticky enable";
      };
    };
  };
}