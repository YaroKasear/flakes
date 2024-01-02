{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayland;
in {
  options.united.wayland = {
    enable = mkEnableOption "Wayland";
  };

  config = mkIf cfg.enable {
    united.greetd.enable = true;

    programs.hyprland.enable = true;
  };
}