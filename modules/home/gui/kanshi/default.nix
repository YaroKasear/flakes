{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.kanshi;

  stringList = lib.concatMapStrings (x: x + " ");
in {
  options.united.kanshi = {
    enable = mkEnableOption "kanshi";
  };

  config = mkIf cfg.enable {
  };
}