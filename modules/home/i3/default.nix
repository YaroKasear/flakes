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
    };

    home = {
      file = {
        layout = {
          source = ../../../files/i3/layout.json;
          target = ".config/i3/layout.json";
        };
        i3-wsman-config = {
          source = ../../../files/i3/i3-wsman.toml;
          target = ".config/i3/i3-wsman.toml";
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
        united.i3-wsman
        wp-gen

      ];
    };

    programs = {
      i3status.enable = true;
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
          terminal = "kitty";
          modifier = "Mod4";
          menu = "${pkgs.rofi}/bin/rofi -show drun";
          fonts = {
            names = ["FiraCode Nerd Font"];
          };
          keybindings = let
            modifier = config.xsession.windowManager.i3.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+1" = "exec --no-startup-id i3-wsman goto 1";
            "${modifier}+2" = "exec --no-startup-id i3-wsman goto 2";
            "${modifier}+3" = "exec --no-startup-id i3-wsman goto 3";
            "${modifier}+4" = "exec --no-startup-id i3-wsman goto 4";
            "${modifier}+5" = "exec --no-startup-id i3-wsman goto 5";
            "${modifier}+6" = "exec --no-startup-id i3-wsman goto 6";
            "${modifier}+7" = "exec --no-startup-id i3-wsman goto 7";
            "${modifier}+8" = "exec --no-startup-id i3-wsman goto 8";
            "${modifier}+9" = "exec --no-startup-id i3-wsman goto 9";
            "${modifier}+0" = "exec --no-startup-id i3-wsman goto 10";
            "${modifier}+Ctrl+Left" = "exec --no-startup-id i3-wsman prev create group nogroup output";
            "${modifier}+Ctrl+Right" = "exec --no-startup-id i3-wsman next create group nogroup output";
            "${modifier}+Ctrl+Shift+Left" = "exec --no-startup-id i3-wsman reorder left";
            "${modifier}+Ctrl+Shift+Right" = "exec --no-startup-id i3-wsman reorder right";
            "${modifier}+Ctrl+Mod1+Left" = "exec --no-startup-id i3-wsman adjacent left";
            "${modifier}+Ctrl+Mod1+Right" = "exec --no-startup-id i3-wsman adjacent right";
            "${modifier}+Shift+g" = "exec --no-startup-id i3-input -F 'exec --no-startup-id \"i3-wsman group assign %s\"' -P 'Group: '";
            "${modifier}+Shift+n" = "exec --no-startup-id i3-input -F 'exec --no-startup-id \"i3-wsman rename %s\"' -P 'Workspace Name: '";
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
            { command = "kitty"; notification = false; }
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