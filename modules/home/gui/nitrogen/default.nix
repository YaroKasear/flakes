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
      packages = with pkgs; [
        nitrogen
      ];
    };

    xdg.configFile = {
      "nitrogen/bg-saved.cfg".source = ./files/bg-saved.cfg;
      "nitrogen/nitrogen.cfg".source = ./files/nitrogen.cfg;
    };
  };
}