{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayland;
in {
  options.united.wayland = {
    enable = mkEnableOption "Wayland";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [catppuccin-sddm-corners];

    services = {
        displayManager = {
          sddm = {
            enable = true;
            # package = mkForce pkgs.libsForQt5.sddm;
            wayland = enabled;
            settings = {
              General.Numlock = "on";
            };
            # extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
            # theme = "catppuccin-sddm-corners";
          };
          defaultSession = "plasma";
        };
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };
  };
}