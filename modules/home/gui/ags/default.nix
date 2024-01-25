{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.ags;
in {
  options.united.ags = {
    enable = mkEnableOption "Enable Aylur's Gtk Shell!";
  };

  config = mkIf cfg.enable {
    programs.ags = {
      enable = true;
    };

    xdg.configFile = {
      "ags" = {
        source = ./files;
        recursive = true;
      };
    };
  };
}
