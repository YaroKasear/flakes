{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.picom;
in {
  options.united.picom = {
    enable = mkEnableOption "Picom";
  };

  config = mkIf cfg.enable {
    services = {
      picom = {
        enable = true;
        backend = "glx";
        fade = true;
        shadow = true;
        settings = {
          corner-radius = 10;
          round-borders = 1;
        };
      };
    };
  };
}