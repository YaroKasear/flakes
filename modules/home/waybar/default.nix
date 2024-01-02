{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.waybar;
in {
  options.united.waybar = {
    enable = mkEnableOption "Waybar";
  };

  config = mkIf cfg.enable {
    home.file.waybar-css = {
      source = ../../../files/waybar/waybar.css;
      target = ".config/waybar/waybar.css";
    };

    programs.waybar = with config.united.user.colors; {
      enable = true;
      settings = {
        topBar = {
          layer = "top";
          spacing = 4;
          height = 24;
          margin-top = 10;
          modules-left = [
            "wireplumber"
          ];
          modules-center = [
              "custom/spacer"
              "cava"
          ];
          modules-right = [
            "custom/spacer"
            "group/group-power"
            "clock"
          ];
          name = "topBar";
          wireplumber = {
            format = " {volume}% ";
            scroll-step = 5.0;
          };
          "custom/spacer" = {
            format = " ";
          };
          cava = {
            format-icons = [
              "▁"
              "▂"
              "▃"
              "▄"
              "▅"
              "▆"
              "▇"
              "█"
            ];
          };
          clock = {
            format = "{:%A, %B %d, %Y (%r)}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              on-click-right = "mode";
              format = with config.united.user.colors; {
                months = "<span color='${white}'><b>{}</b></span>";
                days = "<span color='${primary}'><b>{}</b></span>";
                weeks = "<span color='${pink}'><b>W{}</b></span>";
                weekdays = "<span color='${yellow}'><b>{}</b></span>";
                today = "<span color='${white}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          "group/group-power" = {
            orientation = "inherit";
            drawer = {
              transition-duration = 500;
              children-class = "not-power";
              transition-left-to-right = false;
            };
            modules = [
              "custom/power"
              "custom/reboot"
              "custom/quit"
            ];
          };
          "custom/quit" = {
            format = "󰗼 ";
            tooltip = false;
            on-click = "hyprctl dispatch exit";
          };
          "custom/reboot" = {
            format = "󰜉 ";
            tooltip = false;
            on-click = "reboot";
          };
          "custom/power" = {
            format = " ";
            tooltip = false;
            on-click = "shutdown now";
          };
        };
        bottomBar = {
          layer = "top";
          height = 24;
          spacing = 4;
          name = "bottomBar";
          position = "bottom";
          margin-bottom = 10;
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = ["group/status"];
          user = {
            icon = true;
            format = " {user} ";
          };
          "custom/spacer" = {
            format = " ";
          };
          "hyprland/workspaces" = {
            format = "{id}";
            on-scroll-up = "hyprctl dispatch workspace e-1";
            on-scroll-down = "hyprctl dispatch workspace e+1";
          };
          "hyprland/window" = {
            format = " {title} ";
          };
          "group/status" = {
            orientation = "inherit";
            modules = [ "custom/spacer" "tray" "custom/spacer" "user" ];
          };
        };
      };
      style = ''
        @define-color primary ${primary};
        @define-color secondary ${secondary};
        @define-color tertiary ${tertiary};
        @define-color window ${window};
        @define-color alert ${alert};
        @define-color white ${white};
        @define-color black ${black};
        @define-color red ${red};
        @define-color green ${green};
        @define-color yellow ${yellow};
        @define-color blue ${blue};
        @define-color purple ${purple};
        @define-color cyan ${cyan};
        @define-color pink ${pink};
        @define-color orange ${orange};

        @import url("waybar.css");
      '';
    };

    united.cava.enable = true;
  };
}