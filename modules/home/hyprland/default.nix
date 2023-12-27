{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.hyprland;
in {
  options.united.hyprland = {
    enable = mkEnableOption "Hyprland";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libsForQt5.qt5.qtwayland
      libsForQt5.qt5ct
      libva
      vaapiVdpau
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind =
          [
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );
        };
        extraConfig = ''
          env = LIBVA_DRIVER_NAME,nvidia
          env = XDG_SESSION_TYPE,wayland
          env = GBM_BACKEND,nvidia-drm
          env = __GLX_VENDOR_LIBRARY_NAME,nvidia
          env = WLR_NO_HARDWARE_CURSORS,1
        '';
    };
  };
}
