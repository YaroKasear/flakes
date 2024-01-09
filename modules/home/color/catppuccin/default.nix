{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

  cfg = config.united.color.catppuccin;
in {
  options.united.color.catppuccin = {
    enable = mkEnableOption "Default settings not to be overridden by Catppuccin themes.";
  };

  config = mkIf cfg.enable {
    programs.tmux.extraConfig = ''
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      set -g default-terminal "''${TERM}"
      set -ga terminal-overrides ",xterm-*:Tc"
      bind-key -n Home send Escape "OH"
      bind-key -n End send Escape "OF"
      unbind C-Space
      set -g prefix C-Space
      bind C-Space send-prefix
      bind-key "|" split-window -h -c "#{pane_current_path}"
      bind-key "\\" split-window -fh -c "#{pane_current_path}"
      bind-key "-" split-window -v -c "#{pane_current_path}"
      bind-key "_" split-window -fv -c "#{pane_current_path}"
    '';
  };
}
