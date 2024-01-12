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
  };
}