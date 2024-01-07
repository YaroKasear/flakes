{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  cfg = config.united.tmux;
in {
  options.united.tmux = {
    enable = mkEnableOption "Tmux";
  };

  config = mkIf cfg.enable {
    xdg.configFile."tmuxinator/mucks.yml".source = mkIf is-linux ./files/mucks.yml;

    programs = {
      tmux = {
        enable = true;
        mouse = true;
        historyLimit = 5000;
        tmuxinator.enable = true;
        extraConfig = with config.united.user.colors;
        ''
          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
          unbind C-Space
          set -g prefix C-Space
          bind C-Space send-prefix
          bind-key "|" split-window -h -c "#{pane_current_path}"
          bind-key "\\" split-window -fh -c "#{pane_current_path}"
          bind-key "-" split-window -v -c "#{pane_current_path}"
          bind-key "_" split-window -fv -c "#{pane_current_path}"
          set -g default-terminal "''${TERM}"
          set -ga terminal-overrides ",xterm-*:Tc"
          bind-key -n Home send Escape "OH"
          bind-key -n End send Escape "OF"
          set -g status-right-length 40
          set -g status-left-length 40
          set -g status-style bg='${background}',fg='${selection_background},bold,noreverse'
          set -g status-left '#[bg=${background}]#[fg=${selection_background}]#{?client_prefix,#[bg=${background}]#[fg=${red}],}'
          set -ga status-left '#[bg=${selection_background}]#[fg=${selection_foreground}]#{?client_prefix,#[bg=${red}],} #(whoami)@#(hostname) #(uname) #(uname -r) '
          set -ga status-left '#[bg=${background}]#[fg=${selection_background}]#{?client_prefix,#[bg=${background}]#[fg=${red}],}'
          set -g status-justify absolute-centre
          set-window-option -g window-status-style bg='${selection_foreground},fg=${selection_background},bold,noreverse'
          set-window-option -g window-status-current-style bg='${selection_background}',fg='${selection_foreground},bold,noreverse'
          set-window-option -g window-status-activity-style 'bold,noreverse'
          set-window-option -g window-status-bell-style 'bold,noreverse'
          set -g window-status-current-format "#[fg=${selection_background}]#[bg=${background}]#[fg=${selection_foreground}]#[bg=${selection_background}] #I #W #[fg=${selection_background}]#[bg=${background}]"
          set -g window-status-format "#[fg=${selection_foreground}]#[bg=${background}]#{?window_bell_flag,#[bg=${background}]#[fg=${red}],}"
          set -ga window-status-format "#[fg=${selection_background}]#[bg=${selection_foreground}]#{?window_bell_flag,#[bg=${red}]#[fg=${selection_foreground}],} #I #W "
          set -ga window-status-format "#[bg=${background}]#[fg=${selection_foreground}]#{?window_bell_flag,#[bg=${background}]#[fg=${red}],}"
          set -ga status-right '#[bg=${selection_background}]#[fg=${selection_foreground}] %a %H:%M:%S %Y-%m-%d #[bg=${background}]#[fg=${selection_background}]'
        '';
      };
    };
  };
}