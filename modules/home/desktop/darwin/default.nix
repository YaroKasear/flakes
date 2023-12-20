{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.desktop.darwin;
in {
  options.united.desktop.darwin = {
    enable = mkEnableOption "Darwin Desktop";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [

      ];
    };
  };
}