{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.hyprland;
  home-directory = config.united.user.home-directory;
  pictures-directory = "${home-directory}/Pictures";
in {
  options.united.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim
        libsForQt5.qt5.qtwayland
        libsForQt5.qt5ct
        libva
        hyprpaper
        inputs.hyprpicker.packages.x86_64-linux.hyprpicker
        slurp
        swaynotificationcenter
        wl-clipboard
        xdg-desktop-portal-hyprland
        xwaylandvideobridge
      ];
    };

    xdg.configFile."hypr/hyprpaper.conf".source = ./files/hyprpaper.conf;

    programs.wofi.enable = true;

    services.cliphist.enable = true;

    united = {
      gammastep.enable = true;
      kitty.enable = true;
      waybar.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      settings = with config.united.color; {
        "$black" = "rgb(${lib.replaceStrings ["#"] [""] black})";
        "$red" = "rgb(${lib.replaceStrings ["#"] [""] red})";
        "$green" = "rgb(${lib.replaceStrings ["#"] [""] green})";
        "$yellow" = "rgb(${lib.replaceStrings ["#"] [""] yellow})";
        "$blue" = "rgb(${lib.replaceStrings ["#"] [""] blue})";
        "$magenta" = "rgb(${lib.replaceStrings ["#"] [""] magenta})";
        "$cyan" = "rgb(${lib.replaceStrings ["#"] [""] cyan})";
        "$white" = "rgb(${lib.replaceStrings ["#"] [""] white})";
        "$black_dull" = "rgb(${lib.replaceStrings ["#"] [""] black_dull})";
        "$black_bright" = "rgb(${lib.replaceStrings ["#"] [""] black_bright})";
        "$red_dull" = "rgb(${lib.replaceStrings ["#"] [""] red_dull})";
        "$red_bright" = "rgb(${lib.replaceStrings ["#"] [""] red_bright})";
        "$green_dull" = "rgb(${lib.replaceStrings ["#"] [""] green_dull})";
        "$green_bright" = "rgb(${lib.replaceStrings ["#"] [""] green_bright})";
        "$yellow_dull" = "rgb(${lib.replaceStrings ["#"] [""] yellow_dull})";
        "$yellow_bright" = "rgb(${lib.replaceStrings ["#"] [""] yellow_bright})";
        "$blue_dull" = "rgb(${lib.replaceStrings ["#"] [""] blue_dull})";
        "$blue_bright" = "rgb(${lib.replaceStrings ["#"] [""] blue_bright})";
        "$magenta_dull" = "rgb(${lib.replaceStrings ["#"] [""] magenta_dull})";
        "$magenta_bright" = "rgb(${lib.replaceStrings ["#"] [""] magenta_bright})";
        "$cyan_dull" = "rgb(${lib.replaceStrings ["#"] [""] cyan_dull})";
        "$cyan_bright" = "rgb(${lib.replaceStrings ["#"] [""] cyan_bright})";
        "$white_dull" = "rgb(${lib.replaceStrings ["#"] [""] white_dull})";
        "$white_bright" = "rgb(${lib.replaceStrings ["#"] [""] white_bright})";
        "$foreground" = "rgb(${lib.replaceStrings ["#"] [""] foreground})";
        "$background" = "rgb(${lib.replaceStrings ["#"] [""] background})";
        "$selection_foreground" = "rgb(${lib.replaceStrings ["#"] [""] selection_foreground})";
        "$selection_background" = "rgb(${lib.replaceStrings ["#"] [""] selection_background})";
        "$cursor" = "rgb(${lib.replaceStrings ["#"] [""] cursor})";
        "$cursor_text_color" = "rgb(${lib.replaceStrings ["#"] [""] cursor_text_color})";
        "$url_color" = "rgb(${lib.replaceStrings ["#"] [""] url_color})";
        "$visual_bell_color" = "rgb(${lib.replaceStrings ["#"] [""] visual_bell_color})";
        "$active_border_color" = "rgb(${lib.replaceStrings ["#"] [""] active_border_color})";
        "$inactive_border_color" = "rgb(${lib.replaceStrings ["#"] [""] inactive_border_color})";
        "$bell_border_color" = "rgb(${lib.replaceStrings ["#"] [""] bell_border_color})";
        "$active_tab_foreground" = "rgb(${lib.replaceStrings ["#"] [""] active_tab_foreground})";
        "$active_tab_background" = "rgb(${lib.replaceStrings ["#"] [""] active_tab_background})";
        "$inactive_tab_foreground" = "rgb(${lib.replaceStrings ["#"] [""] inactive_tab_foreground})";
        "$inactive_tab_background" = "rgb(${lib.replaceStrings ["#"] [""] inactive_tab_background})";
        "$tab_bar_background" = "rgb(${lib.replaceStrings ["#"] [""] tab_bar_background})";
        "$tab_bar_margin_color" = "rgb(${lib.replaceStrings ["#"] [""] tab_bar_margin_color})";
        "$mark1_background" = "rgb(${lib.replaceStrings ["#"] [""] mark1_background})";
        "$mark1_foreground" = "rgb(${lib.replaceStrings ["#"] [""] mark1_foreground})";
        "$mark2_background" = "rgb(${lib.replaceStrings ["#"] [""] mark2_background})";
        "$mark2_foreground" = "rgb(${lib.replaceStrings ["#"] [""] mark2_foreground})";
        "$mark3_background" = "rgb(${lib.replaceStrings ["#"] [""] mark3_background})";
        "$mark3_foreground" = "rgb(${lib.replaceStrings ["#"] [""] mark3_foreground})";
        "$color0" = "rgb(${lib.replaceStrings ["#"] [""] color0})";
        "$color1" = "rgb(${lib.replaceStrings ["#"] [""] color1})";
        "$color2" = "rgb(${lib.replaceStrings ["#"] [""] color2})";
        "$color3" = "rgb(${lib.replaceStrings ["#"] [""] color3})";
        "$color4" = "rgb(${lib.replaceStrings ["#"] [""] color4})";
        "$color5" = "rgb(${lib.replaceStrings ["#"] [""] color5})";
        "$color6" = "rgb(${lib.replaceStrings ["#"] [""] color6})";
        "$color7" = "rgb(${lib.replaceStrings ["#"] [""] color7})";
        "$color8" = "rgb(${lib.replaceStrings ["#"] [""] color8})";
        "$color9" = "rgb(${lib.replaceStrings ["#"] [""] color9})";
        "$color10" = "rgb(${lib.replaceStrings ["#"] [""] color10})";
        "$color11" = "rgb(${lib.replaceStrings ["#"] [""] color11})";
        "$color12" = "rgb(${lib.replaceStrings ["#"] [""] color12})";
        "$color13" = "rgb(${lib.replaceStrings ["#"] [""] color13})";
        "$color14" = "rgb(${lib.replaceStrings ["#"] [""] color14})";
        "$color15" = "rgb(${lib.replaceStrings ["#"] [""] color15})";

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "swaync"
          "waybar"
          "wallpaper-generator `ls ${inputs.wallpaper-generator.packages.x86_64-linux.wp-gen}/bin/generators | grep .lua | shuf -n 1 | cut -d . -f 1` -o /tmp/background.png --width 2560 --height 1440 && hyprpaper"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "kitty --class=\"kitty-bg\" asciiquarium"
        ];

        monitor = ",highrr,auto,auto";
        "$terminal" = "kitty";
        "$menu" = "wofi --show drun";

        env = [
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "GBM_BACKEND,nvidia-drm"
          "LIBVA_DRIVER_NAME,nvidia"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_DRM_NO_ATOMIC,1"
          "XCURSOR_SIZE,24"
          "XDG_CURRENT_DESKTOP=Hyprland"
          "XDG_SESSION_DESKTOP=Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "__GL_GSYNC_ALLOWED,1"
        ];

        input = {
          numlock_by_default = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.inactive_border" = "$inactive_border_color";
          "col.active_border" = "$active_border_color";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true;
        };

        group = {
          "col.border_active" = "$active_border_color";
          "col.border_inactive" = "$inactive_border_color";
          groupbar = {
            "col.active" = "$active_tab_background";
            "col.inactive" = "$inactive_tab_background";
            font_family = "FiraCode Nerd Font";
            font_size = 10;
            gradients = true;
            render_titles = true;
          };
        };

        decoration = {
          rounding = 10;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
        };

        dwindle = {
          smart_split = true;
          smart_resizing = true;
        };

        master = {
          allow_small_split = true;
          new_is_master = false;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        misc = {
          background_color = "$background";
          disable_hyprland_logo = true;
          vrr = 1;
        };

        windowrulev2 = [
          "nomaximizerequest, class:.*"
          "float, title:^(Picture-in-Picture)$"
          "size 800 450, title:(Picture-in-Picture)"
          "pin, title:^(Picture-in-Picture)$"
          "float, title:^(Firefox)$"
          "size 800 450, title:(Firefox)"
          "pin, title:^(Firefox)"
          "immediate, class:^(cs2)$"
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
        ];

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod, E, togglegroup,"
          "$mainMod, code:65, togglefloating,"
          "$mainMod SHIFT, code:65, pin,"
          "$mainMod SHIFT, N, exec, swanc-client -t sw"
          "$mainMod, D, exec, $menu"
          "$mainMod, F, fullscreen,"
          "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          "$mainMod SHIFT, P, exec, hyprpicker | wl-copy"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, left, swapnext, prev"
          "$mainMod SHIFT, right, swapnext,"
          ",Print,exec,grim ${pictures-directory}/Screenshots/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png')"
          "SHIFT,Print,exec,slurp | grim -g - ${pictures-directory}/Screenshots/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png')"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
      extraConfig = ''
        plugin {
          hyprwinwrap {
            class = kitty-bg
            size: 100%;
          }
        }
      '';
    };
  };
}
