{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.ranger;
in {
  options.united.ranger = {
    enable = mkEnableOption "Ranger";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ranger ];

    xdg.configFile.ranger.source = ./files;
  };
}