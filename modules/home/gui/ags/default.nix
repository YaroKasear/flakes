{ lib, config, pkgs, inputs, ... }:

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
      package = inputs.ags.packages.${pkgs.system}.agsWithTypes;
    };

    xdg.configFile = {
      "ags" = {
        source = ./files;
        recursive = true;
      };
      "ags/types" = {
        source = "${inputs.ags.packages.${pkgs.system}.agsWithTypes}/share/com.github.Aylur.ags/types";
        recursive = true;
      };
    };
  };
}
