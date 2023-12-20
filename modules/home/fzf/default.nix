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
          fg = primary;
          bg = tertiary;
          "fg+" = secondary;
          "bg+" = primary;
          hl = white;
          preview-fg = primary;
          preview-bg = tertiary;
        };
        tmux.enableShellIntegration = true;
      };
    };
  };
}