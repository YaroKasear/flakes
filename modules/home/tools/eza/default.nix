{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.eza;
in {
  options.united.eza = {
    enable = mkEnableOption "Eza";
  };

  config = mkIf cfg.enable {
    programs = {
      eza = {
        enable = true;
        git = true;
        icons = "auto";
      };
    };
  };
}