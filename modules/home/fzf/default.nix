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
        colors = with config.united.user.colors; {
          fg = foreground;
          bg = background;
          "fg+" = selection_foreground;
          "bg+" = selection_background;
          hl = white;
          preview-fg = foreground;
          preview-bg = background;
        };
        tmux.enableShellIntegration = true;
      };
    };
  };
}