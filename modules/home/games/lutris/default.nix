{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.lutris;

in {
  options.united.lutris = {
    enable = mkEnableOption "Lutris";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
      heroic
    ];
  };
}
