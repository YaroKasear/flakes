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
    xdg.configFile."waybar/waybar.css".source = ./files/waybar.css;

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
                days = "<span color='${foreground}'><b>{}</b></span>";
                weeks = "<span color='${magenta}'><b>W{}</b></span>";
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
        @define-color black ${black};
        @define-color red ${red};
        @define-color green ${green};
        @define-color yellow ${yellow};
        @define-color blue ${blue};
        @define-color magenta ${magenta};
        @define-color cyan ${cyan};
        @define-color white ${white};
        @define-color black_dull ${black_dull};
        @define-color black_bright ${black_bright};
        @define-color red_dull ${red_dull};
        @define-color red_bright ${red_bright};
        @define-color green_dull ${green_dull};
        @define-color green_bright ${green_bright};
        @define-color yellow_dull ${yellow_dull};
        @define-color yellow_bright ${yellow_bright};
        @define-color blue_dull ${blue_dull};
        @define-color blue_bright ${blue_bright};
        @define-color magenta_dull ${magenta_dull};
        @define-color magenta_bright ${magenta_bright};
        @define-color cyan_dull ${cyan_dull};
        @define-color cyan_bright ${cyan_bright};
        @define-color white_dull ${white_dull};
        @define-color white_bright ${white_bright};
        @define-color foreground ${foreground};
        @define-color background ${background};
        @define-color selection_foreground ${selection_foreground};
        @define-color selection_background ${selection_background};
        @define-color cursor ${cursor};
        @define-color cursor_text_color ${cursor_text_color};
        @define-color url_color ${url_color};
        @define-color visual_bell_color ${visual_bell_color};
        @define-color active_border_color ${active_border_color};
        @define-color inactive_border_color ${inactive_border_color};
        @define-color bell_border_color ${bell_border_color};
        @define-color active_tab_foreground ${active_tab_foreground};
        @define-color active_tab_background ${active_tab_background};
        @define-color inactive_tab_foreground ${inactive_tab_foreground};
        @define-color inactive_tab_background ${inactive_tab_background};
        @define-color tab_bar_background ${tab_bar_background};
        @define-color tab_bar_margin_color ${tab_bar_margin_color};
        @define-color mark1_background ${mark1_background};
        @define-color mark1_foreground ${mark1_foreground};
        @define-color mark2_background ${mark2_background};
        @define-color mark2_foreground ${mark2_foreground};
        @define-color mark3_background ${mark3_background};
        @define-color mark3_foreground ${mark3_foreground};
        @define-color color0 ${color0};
        @define-color color1 ${color1};
        @define-color color2 ${color2};
        @define-color color3 ${color3};
        @define-color color4 ${color4};
        @define-color color5 ${color5};
        @define-color color6 ${color6};
        @define-color color7 ${color7};
        @define-color color8 ${color8};
        @define-color color9 ${color9};
        @define-color color10 ${color10};
        @define-color color11 ${color11};
        @define-color color12 ${color12};
        @define-color color13 ${color13};
        @define-color color14 ${color14};
        @define-color color15 ${color15};

        @import url("waybar.css");
      '';
    };

    united.cava.enable = true;
  };
}