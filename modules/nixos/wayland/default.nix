{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayland;
in {
  options.united.wayland = {
    enable = mkEnableOption "Wayland";
    greeter = mkEnableOption "Use greeter";
    compositor = mkOption {
      type = types.enum [
        "hyprland"
        "plasma"
      ];
      default = "hyprland";
      description = "Select compositor!";
    };
  };

  config = mkIf cfg.enable {
    united.greetd.enable = cfg.greeter;

    programs.hyprland = {
      enable = cfg.compositor == "hyprland";
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    services = mkIf (cfg.compositor == "plasma") {
      xserver = {
        enable = true;
        displayManager = {
          sddm.enable = true;
          defaultSession = "plasma";
        };
      };
      desktopManager.plasma6.enable = true;
    };
  };
}