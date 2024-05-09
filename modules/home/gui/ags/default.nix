{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.ags;
in {
  options.united.ags = {
    enable = mkEnableOption "ags";
  };

  config = mkIf cfg.enable {
    programs.ags.enable = true;
  };
}
