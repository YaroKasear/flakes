{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

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