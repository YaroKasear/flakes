{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.qt;
in {
  options.united.qt = {
    enable = mkEnableOption "Module for the Qt toolkit!";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (mkIf config.united.wayland.enable libsForQt5.qt5.qtwayland)
        libsForQt5.qt5ct
      ];
    };

    qt = {
      enable = true;
      platformTheme = "gtk3";
    };
  };
}