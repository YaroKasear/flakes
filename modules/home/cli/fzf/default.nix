{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.fzf;
in {
  options.united.fzf = {
    enable = mkEnableOption "Fzf";
  };

  config = mkIf cfg.enable {
    programs = {
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        colors = with config.united.style; {
          fg = mkDefault foreground;
          bg = mkDefault background;
          "fg+" = mkDefault selection_foreground;
          "bg+" = mkDefault selection_background;
          hl = mkDefault white;
          preview-fg = mkDefault foreground;
          preview-bg = mkDefault background;
        };
        tmux.enableShellIntegration = true;
      };
    };
  };
}