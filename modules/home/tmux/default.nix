{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.tmux;
in {
  options.united.tmux = {
    enable = mkEnableOption "Tmux";
  };

  config = mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;
        mouse = true;
        tmuxinator.enable = true;
      };
    };
  };
}