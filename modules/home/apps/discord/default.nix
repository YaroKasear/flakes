{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.discord;

in {
  options.united.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    home.packages = [(pkgs.discord.override {
      withOpenASAR = true;
    })];
  };
}