{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nitrogen;
in {
  options.united.nitrogen = {
    enable = mkEnableOption "nitrogen";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; {
        nitrogen
      };
      file = {
        bg-saved = {
          source = ../../../files/nitrogen/bg-saved.cfg;
          target = ".config/nitrogen/bg-saved.cfg"
        };
        nitrogen = {
          source = ../../../files/nitrogen/nitrogen.cfg;
          target = ".config/nitrogen/nitrogen.cfg"
        };
      };
    };
  };
}