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
    programs.waybar = {
      enable = true;
      settings = {
        topBar = {
          layer = "top";
          height = 32;
          modules-left = [
            "cava"
            "wireplumber"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "group/group-power"
          ];
          name = "topBar";
          # mode = "dock";
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
            format = "󰗼";
            tooltip = false;
            on-click = "hyprctl dispatch exit";
          };
          "custom/reboot" = {
            format = "󰜉";
            tooltip = false;
            on-click = "reboot";
          };
          "custom/power" = {
            format = "";
            tooltip = false;
            on-click = "shutdown now";
          };
        };
        bottomBar = {
          layer = "top";
          height = 32;
          name = "bottomBar";
          position = "bottom";
          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = ["tray" "user"];
          user = {
            format = "{user}";
          };
        };
      };
    };

    united.cava.enable = true;
  };
}