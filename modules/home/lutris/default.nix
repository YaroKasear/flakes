{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

  cfg = config.united.lutris;
in {
  options.united.lutris = {
    enable = mkEnableOption "Lutris";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [
        ];
        extraPkgs = pkgs: [
        ];
      })
      heroic
    ];
  };
}
