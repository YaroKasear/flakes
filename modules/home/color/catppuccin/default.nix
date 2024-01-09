{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (lib.united) mkOpt enabled;

  home-directory = config.united.user.home-directory;

  cfg = config.united.color.catppuccin;
in {
  options.united.color.catppuccin = {
    enable = mkEnableOption "Default settings not to be overridden by Catppuccin themes.";
  };

  config = mkIf cfg.enable {
    programs = {
      tmux.extraConfig = ''
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
      kitty.extraConfig = ''
        enable_audio_bell yes
        window_alert_on_bell yes
        bell_on_tab "🔔 "
        bell_path ${home-directory}/.local/share/sound/bell.oga
        background_opacity 0.8
        background_blur 32
        tab_bar_min_tabs 2

        font_features Fira Code +cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum
        tab_bar_edge                bottom
        tab_bar_style               powerline
        tab_powerline_style         slanted
        tab_title_template          {title}{' :{}:'.format(num_windows) if num_windows > 1 else \'\'}
      '';
    };
  };
}
