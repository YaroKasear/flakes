{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayland;
in {
  options.united.wayland = {
    enable = mkEnableOption "Wayland";
    compositor = mkOption {
      type = types.enum [
        "hyprland"
        "plasma"
        "sway"
        "wayfire"
      ];
      default = "hyprland";
      description = "Select compositor!";
    };
  };

  config = mkIf cfg.enable {
    united = {
      hyprland.enable = cfg.compositor == "hyprland";
      sway.enable = cfg.compositor == "sway";
      wayfire.enable = cfg.compositor == "wayfire";
    };
  };
}