{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.redshift;
in {
  options.united.redshift = {
    enable = mkEnableOption "Redshift";
  };

  config = mkIf cfg.enable {
    services.redshift = {
      enable = true;
      latitude = 42.01;
      longitude = -97.25;
      tray = true;
    };
  };
}