{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayland;
in {
  options.united.wayland = {
    enable = mkEnableOption "Wayland";
    compositor = mkOption {
      type = types.enum [
        "plasma"
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
    };

    united.plasma.enable = cfg.compositor == "plasma";
  };
}