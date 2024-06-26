{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.hyprland;
  home-directory = config.united.user.directories.home;
  screenshots-directory = config.united.user.directories.screenshots;
  wallpapers-directory = config.united.user.directories.wallpapers;
in {
  options.united.hyprland = {
    enable = mkEnableOption "Hyprland";
    floating = mkBoolOpt false "Make Hyprland behave as a floating WM instead.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        grim
        libva
        inputs.hyprpaper.packages.x86_64-linux.hyprpaper
        inputs.hyprpicker.packages.x86_64-linux.hyprpicker
        slurp
        swaynotificationcenter
        wl-clipboard
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        xwaylandvideobridge
      ];
    };


    programs.wofi = enabled;

    services.cliphist = enabled;

    united = {
      gammastep = enabled;
      waybar = enabled;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      sourceFirst = true;
      plugins = mkIf cfg.floating [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      ];
      settings = with config.united.style.colors; {
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
          "sleep 30s; hyprpaper"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "sleep 30s; systemctl --user restart nextcloud-client"
          "systemctl --user start random-wallpaper.service"
          "systemctl --user start random-wallpaper.timer"
        ];

        monitor = [
          "DP-3,2560x1440@144,0x0,1"
          "Unknown-1,disable"
        ];
        "$terminal" = "kitty";
        "$menu" = "wofi --show drun";

        env = [
          "__GL_GSYNC_ALLOWED,1"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "GBM_BACKEND,nvidia-drm"
          "LIBVA_DRIVER_NAME,nvidia"
          "NVD_BACKEND,direct"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "WLR_DRM_NO_ATOMIC,1"
          "XCURSOR_SIZE,24"
          "XDG_CURRENT_DESKTOP=Hyprland"
          "XDG_SESSION_DESKTOP=Hyprland"
          "XDG_SESSION_TYPE,wayland"
        ];

        input = {
          numlock_by_default = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = config.united.style.windows.border-size;
          "col.inactive_border" = mkDefault "$inactive_border_color";
          "col.active_border" = mkDefault "$active_border_color";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true;
        };

        group = {
          "col.border_active" = mkDefault "$active_border_color";
          "col.border_inactive" = mkDefault "$inactive_border_color";
          groupbar = {
            "col.active" = mkDefault "$active_tab_background";
            "col.inactive" = mkDefault "$inactive_tab_background";
            font_family = config.united.style.fonts.interface;
            font_size = 10;
            gradients = true;
            render_titles = true;
          };
        };

        decoration = {
          rounding = config.united.style.windows.radius;
          drop_shadow = true;
          "col.shadow" = "rgb(${lib.replaceStrings ["#"] [""] config.united.style.effects.shadow.active-color})";
          "col.shadow_inactive" = "rgb(${lib.replaceStrings ["#"] [""] config.united.style.effects.shadow.inactive-color})";
          shadow_offset = "${toString config.united.style.effects.shadow.offsetX} ${toString config.united.style.effects.shadow.offsetY}";
          shadow_range = config.united.style.effects.shadow.spread;
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
          background_color = mkDefault "$background";
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vrr = 2;
        };

        windowrulev2 = [
          (mkIf cfg.floating "float, class:.*")
          (mkIf cfg.floating "plugin:hyprbars:nobar, title:(Picture-in-Picture)")
          (mkIf cfg.floating "plugin:hyprbars:nobar, class:^(kitty-console)$")
          "suppressevent maximize, class:.*"
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
          "workspace special:console silent, class:^(kitty-console)$"
          "tile, class:^(kitty-console)$"
        ];

        workspace = [
          "special:console,gapsin:0,gapsout:0,border:0,shadow:0,rounding:0,decorate:0,on-created-empty:kitty --class=\"kitty-console\" -T _HIDE_ME_"
        ];

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod, E, togglegroup,"
          "$mainMod, code:65, togglefloating,"
          "$mainMod SHIFT, code:65, pin,"
          "$mainMod SHIFT, N, exec, swaync-client -t sw"
          "ALT, F2, exec, wofi --show run"
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
          ",Print,exec,grim ${screenshots-directory}/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png')"
          "SHIFT,Print,exec,slurp | grim -g - ${screenshots-directory}/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png')"
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
          "$mainMod, code:49, togglespecialworkspace, console"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioStop, exec, playerctl stop"
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        binde = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        plugin = mkIf cfg.floating {
          hyprbars = {
            bar_height = 20;
            hyprbars-button = [
              "rgb(${lib.replaceStrings ["#"] [""] red}), 15, 󰖭, hyprctl dispatch killactive"
              "rgb(${lib.replaceStrings ["#"] [""] green}), 15, 󰖯, hyprctl dispatch fullscreen 1"
            ];
          };
        };

        debug = {
          enable_stdout_logs = true;
          disable_logs = false;
        };
      };
    };

    systemd.user = {
      services.random-wallpaper = {
        Unit = {
          Description = "Change to a random wallpaper!";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${home-directory}/${config.xdg.configFile."hypr/random-wallpaper.sh".target}";
        };
      };
      timers.random-wallpaper = {
        Unit = {
          Description = "Regularly change to a random wallpaper!";
        };
        Timer = {
          OnCalendar = "*:0/30";
        };
      };
    };

    xdg.configFile = let
      awk = "${pkgs.gawk}/bin/awk";
      bin_bash = "#!${pkgs.bash}/bin/bash";
      find = "${pkgs.findutils}/bin/find";
      grep = "${pkgs.gnugrep}/bin/grep";
      hyprctl = "${inputs.hyprland.packages.x86_64-linux.hyprland}/bin/hyprctl";
      shuf = "${pkgs.coreutils-full}/bin/shuf";
    in {
      "hypr/hyprpaper.conf".text = ''
        preload = ${config.united.style.wallpaper}
        wallpaper = DP-3,${config.united.style.wallpaper}
        splash = false
      '';
      "hypr/random-wallpaper.sh" = {
        text = ''
          ${bin_bash}

          directory=${wallpapers-directory}
          monitor=`${hyprctl} monitors | ${grep} Monitor | ${awk} '{print $2}'`
          if [ -d "$directory" ]; then
              random_background=$(${find} $directory \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" \) | ${shuf} -n 1)
              ${hyprctl} hyprpaper unload all
              ${hyprctl} hyprpaper preload $random_background
              ${hyprctl} hyprpaper wallpaper "$monitor, $random_background"
          fi
        '';
        executable = true;
      };
    };
  };
}
