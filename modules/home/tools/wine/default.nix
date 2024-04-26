{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

  cfg = config.united.wine;
in {
  options.united.wine = {
    enable = mkEnableOption "Wine";
  };

  config = mkIf cfg.enable {
    home.packages = if is-wayland
    then
      [
        pkgs.wineWowPackages.waylandFull
      ]
    else
      [
        pkgs.wineWowPackages
      ];
  };
}