{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.gammastep;
in {
  options.united.gammastep = {
    enable = mkEnableOption "Gammastep";
  };

  config = mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      latitude = 42.01;
      longitude = -97.25;
      settings.general = {
        brightness-day = 1.0;
        brightness-night = 0.7;
      };
      tray = true;
    };
  };
}