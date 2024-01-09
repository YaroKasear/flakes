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
    xdg.configFile = mkIf is-linux {
      "tmuxinator/mucks.yml".source = ./files/mucks.yml;
    };

    programs = {
      tmux = {
        enable = true;
        mouse = true;
        historyLimit = 5000;
        tmuxinator.enable = true;
        extraConfig = with config.united.color; mkDefault
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
          set -g message-style bg=${visual_bell_color},fg=${active_tab_foreground},bold
          set -g pane-active-border-style fg=${active_border_color}
          set -g pane-border-style fg=${inactive_border_color}
          set -g status-style bg='${background}',fg='${active_tab_background},bold,noreverse'
          set -g status-left '#[bg=${background}]#[fg=${active_tab_background}]#{?client_prefix,#[bg=${background}]#[fg=${visual_bell_color}],}'
          set -ga status-left '#[bg=${active_tab_background}]#[fg=${active_tab_foreground}]#{?client_prefix,#[bg=${visual_bell_color}],} #(whoami)@#(hostname) #(uname) #(uname -r) '
          set -ga status-left '#[bg=${background}]#[fg=${active_tab_background}]#{?client_prefix,#[bg=${background}]#[fg=${visual_bell_color}],}'
          set -g status-justify absolute-centre
          set-window-option -g window-status-style bg='${active_tab_foreground},fg=${active_tab_background},bold,noreverse'
          set-window-option -g window-status-current-style bg='${active_tab_background}',fg='${active_tab_foreground},bold,noreverse'
          set-window-option -g window-status-activity-style 'bold,noreverse'
          set-window-option -g window-status-bell-style 'bold,noreverse'
          set -g window-status-current-format "#[fg=${active_tab_background}]#[bg=${background}]#[fg=${active_tab_foreground}]#[bg=${active_tab_background}] #I #W #[fg=${active_tab_background}]#[bg=${background}]"
          set -g window-status-format "#[fg=${inactive_tab_background}]#[bg=${background}]#{?window_bell_flag,#[bg=${background}]#[fg=${visual_bell_color}],}"
          set -ga window-status-format "#[fg=${inactive_tab_foreground}]#[bg=${inactive_tab_background}]#{?window_bell_flag,#[bg=${visual_bell_color}]#[fg=${active_tab_foreground}],} #I #W "
          set -ga window-status-format "#[fg=${inactive_tab_background}]#[bg=${background}]#{?window_bell_flag,#[bg=${background}]#[fg=${visual_bell_color}],}"
          set -g status-right '#[fg=${active_tab_background}]#[bg=${background}]#[bg=${active_tab_background}]#[fg=${active_tab_foreground}] %a %H:%M:%S %Y-%m-%d #[bg=${background}]#[fg=${active_tab_background}]'
        '';
      };
    };
  };
}