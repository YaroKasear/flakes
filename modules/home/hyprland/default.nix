{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.hyprland;
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
        slurp
        swaynotificationcenter
        xdg-desktop-portal-hyprland
        xwaylandvideobridge
      ];
      file.hyprpaper-conf = {
        source = ../../../files/hypr/hyprpaper.conf;
        target = ".config/hypr/hyprpaper.conf";
      };
    };

    programs.wofi.enable = true;

    united = {
      gammastep.enable = true;
      kitty.enable = true;
      waybar.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = with config.united.user.colors; {
        "$primary" = "rgb(${lib.replaceStrings ["#"] [""] primary})";
        "$secondary" = "rgb(${lib.replaceStrings ["#"] [""] secondary})";
        "$tertiary" = "rgb(${lib.replaceStrings ["#"] [""] tertiary})";
        "$window" = "rgb(${lib.replaceStrings ["#"] [""] window})";
        "$alert" = "rgb(${lib.replaceStrings ["#"] [""] alert})";
        "$white" = "rgb(${lib.replaceStrings ["#"] [""] white})";
        "$black" = "rgb(${lib.replaceStrings ["#"] [""] black})";
        "$red" = "rgb(${lib.replaceStrings ["#"] [""] red})";
        "$green" = "rgb(${lib.replaceStrings ["#"] [""] green})";
        "$yellow" = "rgb(${lib.replaceStrings ["#"] [""] yellow})";
        "$blue" = "rgb(${lib.replaceStrings ["#"] [""] blue})";
        "$purple" = "rgb(${lib.replaceStrings ["#"] [""] purple})";
        "$cyan" = "rgb(${lib.replaceStrings ["#"] [""] cyan})";
        "$pink" = "rgb(${lib.replaceStrings ["#"] [""] pink})";
        "$orange" = "rgb(${lib.replaceStrings ["#"] [""] orange})";

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "swaync"
          "waybar"
          "wallpaper-generator `ls ${inputs.wallpaper-generator.packages.x86_64-linux.wp-gen}/bin/generators | grep .lua | shuf -n 1 | cut -d . -f 1` -o /tmp/background.png --width 2560 --height 1440 && hyprpaper"
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
          "col.inactive_border" = "$secondary";
          "col.active_border" = "$primary";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true;
        };

        group = {
          "col.border_active" = "$primary";
          "col.border_inactive" = "$secondary";
          groupbar = {
            "col.active" = "$primary";
            "col.inactive" = "$secondary";
            font_family = "FiraCode Nerd Font";
            font_size = 10;
            gradients = false;
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
          background_color = "$tertiary";
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
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, left, swapnext, prev"
          "$mainMod SHIFT, right, swapnext,"
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
    };
  };
}
