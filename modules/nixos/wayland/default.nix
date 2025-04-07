{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayland;
in
{
  options.united.wayland = {
    enable = mkEnableOption "Wayland";
    compositor = mkOption {
      type = types.enum [
        "plasma"
        "sway"
        "wayfire"
      ];
      default = "plasma";
      description = "Select compositor!";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      wayfire = mkIf (cfg.compositor == "wayfire") {
        enable = true;
        plugins = with pkgs.wayfirePlugins; [
          wcm
          wf-shell
          wayfire-plugins-extra
        ];
      };
      # sway = mkIf (cfg.compositor == "sway") {
      #   enable = true;
      #   wrapperFeatures.gtk = true;
      # };
    };

    united = {
      plasma.enable = cfg.compositor == "plasma";
      sway.enable = cfg.compositor == "sway";
    };
  };
}
