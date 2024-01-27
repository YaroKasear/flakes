{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.cava;
in {
  options.united.cava = {
    enable = mkEnableOption "Cava";
  };

  config = mkIf cfg.enable {
    programs = {
      cava = {
        enable = true;
        settings = {
          general = {
            framerate = 30;
            autosens = 1;
            bars = 10;
          };
          output = {
            bar_delimiter = 32;
          };
          color = with config.united.style.colors; mkDefault {
            foreground = "'${foreground}'";
            background = "'${background}'";
          };
        };
      };
    };
  };
}
