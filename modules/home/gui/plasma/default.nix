{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.plasma;
in {
  options.united.plasma = {
    enable = mkEnableOption "Plasma";
  };

  config = mkIf cfg.enable {
  };
}