{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.kanshi;

  stringList = lib.concatMapStrings (x: x + " ");
in {
  options.united.kanshi = {
    enable = mkEnableOption "kanshi";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.kanshi];

    services.kanshi = {
      enable = true;
      profiles.main = {
        outputs = [
          {
            criteria = "DP-3";
            mode = "2560x1440@144Hz";
            adaptiveSync = true;
          }
        ];
      };
    };
  };
}