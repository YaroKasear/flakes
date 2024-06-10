{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.obs-studio;
in {
  options.united.obs-studio = {
    enable = mkEnableOption "OBS Studio";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}