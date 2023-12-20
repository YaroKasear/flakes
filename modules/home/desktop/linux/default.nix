{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.desktop.linux;
in {
  options.united.desktop.linux = {
    enable = mkEnableOption "Linux Desktop";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [

      ];
    };
  };
}