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
        "wayfire"
      ];
      default = "hyprland";
      description = "Select compositor!";
    };
  };

  config = mkIf cfg.enable {
    united.greetd.enable = cfg.greeter;

    programs = {
      hyprland = mkIf (cfg.compositor == "hyprland") {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      };
      wayfire = mkIf (cfg.compositor == "wayfire") {
        enable = true;
        plugins = with pkgs.wayfirePlugins; [
          wcm
          wf-shell
          wayfire-plugins-extra
        ];
      };
    };

    environment.systemPackages = with pkgs; [catppuccin-sddm-corners];

    services = mkIf (cfg.compositor == "plasma") {
        displayManager = {
          sddm = {
            enable = true;
            package = mkForce pkgs.libsForQt5.sddm;
            wayland = enabled;
            settings = {
              General.Numlock = "on";
            };
            extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
            theme = "catppuccin-sddm-corners";
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