{ lib, config, ... }:

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
        "sway"
        "wayfire"
      ];
      default = "plasma";
      description = "Select compositor!";
    };
  };

  config = mkIf cfg.enable {
    united = {
      plasma.enable = cfg.compositor == "plasma";
      sway.enable = cfg.compositor == "sway";
      wayfire.enable = cfg.compositor == "wayfire";
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}