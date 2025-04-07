{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.sway;
in
{
  options.united.sway = {
    enable = mkEnableOption "Sway";
    monitor = {
      width = mkOpt types.int 2560 "Horizontal resolution.";
      height = mkOpt types.int 1440 "Vertical resolution.";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      swaynag = enabled;
      wrapperFeatures.gtk = true;
      # package = pkgs.swayfx;
      config = {
        bars = [ ];
        menu = "${pkgs.wofi}/bin/wofi --show drun";
        modifier = "Mod4";
        terminal = "kitty";
        defaultWorkspace = "workspace number 1";
        output = {
          DP-3 = {
            mode = "${toString cfg.monitor.width}x${toString cfg.monitor.height}@144Hz";
            bg = "${config.united.style.wallpaper} tile ${config.united.style.colors.background}";
            adaptive_sync = "off";
          };
        };
        startup = [
          {
            command = "waybar";
          }
        ];
        workspaceAutoBackAndForth = true;
      };
      extraConfig = ''
        for_window [app_id="firefox" title="^Picture-in-Picture$"] floating enable, move position ${toString (builtins.floor(cfg.monitor.width * 0.55))} px ${toString (builtins.floor (cfg.monitor.height / 5))} px, resize set width ${toString (builtins.floor(cfg.monitor.width / 4))} px height ${toString (builtins.floor(cfg.monitor.height / 4))} px, sticky enable
        bindsym Mod4+Shift+d exec ${pkgs.wofi}/bin/wofi --show run
      '';
    };

    services.swaync = enabled;

    programs = {
      waybar = {
        enable = true;
        settings = with config.united.style.colors; {
          topbar = {
            layer = "top";
            height = 36;
            modules-left = [
              "sway/workspaces"
              "sway/mode"
              "sway/window"
            ];
            modules-center = [
              "mpris"
            ];
            modules-right = [
              "tray"
              "clock"
            ];
            "sway/window" = {
              icon = true;
            };
            mpris = {
              interval = 1;
              format = "{player_icon} {dynamic}";
              "player-icons" = {
                "default" = "▶";
              };
              "status-icons" = {
                "paused" = "⏸";
              };
            };
            clock = {
              interval = 1;
              format = "{:%A, %B %e, %Y %I:%M %p}";
              tooltip-format = "<tt>{calendar}</tt>";
              calendar = {
                mode = "month";
                format = {
                  days = "<span color='${foreground}'><b>{}</b></span>";
                  weekdays = "<span color='${active_border_color}'><b>{}</b></span>";
                  today = "<span color='${red}'><b>{}</b></span>";
                };
              };
            };
          };
          bottombar = {
            position = "bottom";
            modules-left = [
              "wlr/taskbar"
            ];
            modules-right = [
              "user"
            ];
            user = {
              avatar = config.united.user.icon;
              icon = true;
              format = "  {user}";
            };
            "wlr/taskbar" = {
              format = "{icon} <span color='${foreground}'>{title}</span>";
              markup = true;
              on-click = "activate";
              icon-theme = "Numix-Circle";
              ignore-list = [
                "Picture-in-Picture"
              ];
            };
          };
        };
      };
      wofi = enabled;
    };

    # united.waybar = enabled;

    home = {
      packages = with pkgs; [
        grim
        libva
        slurp
        wl-clipboard
        kdePackages.xwaylandvideobridge
        libnotify
        numix-icon-theme-circle
      ];
      sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        QT_QPA_PLATFORMTHEME = mkForce "qt5ct";
        WLR_NO_HARDWARE_CURSORS = 1;
        WLR_DRM_NO_ATOMIC = 1;
        # WLR_RENDERER = "gles2";
        WLR_RENDERER = "vulkan";
        XCURSOR_SIZE = 24;
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";
        __GL_GSYNC_ALLOWED = 1;
      };
    };
  };
}
