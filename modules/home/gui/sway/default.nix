{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.sway;
in {
  options.united.sway = {
    enable = mkEnableOption "Sway";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      swaynag = enabled;
      config = {
        menu = "wofi --show drun";
        modifier = "Mod4";
        output = {
          DP-3 = {
            mode = "2560x1440@144Hz";
            bg = "${config.united.style.wallpaper} tile ${config.united.style.colors.background}";
            adaptive_sync = "on";
          };
        };
      };
    };

    programs.wofi = enabled;

    home = {
      packages = with pkgs; [
        grim
        libva
        slurp
        swaynotificationcenter
        wl-clipboard
        xwaylandvideobridge
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