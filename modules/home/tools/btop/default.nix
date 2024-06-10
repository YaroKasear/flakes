{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.btop;
in {
  options.united.btop = {
    enable = mkEnableOption "Btop";
  };

  config = mkIf cfg.enable {
    programs = {
      btop = {
        enable = true;
        settings = {
          rounded_corners = true;
          show_battery = false;
          theme_background = false;
          truecolor = true;
          update_ms = 2000;
        };
      };
    };
  };
}