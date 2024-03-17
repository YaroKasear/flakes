{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayfire;
in {
  options.united.wayfire = {
    enable = mkEnableOption "Wayfire";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "wayfire.ini".source = (pkgs.formats.ini { }).generate "wayfire.ini" {
      };
    };
  };
}