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
          set -g status-style bg='${tertiary}',fg='${primary},bold,noreverse'
          set -g status-left '#[bg=${tertiary}]#[fg=${primary}]#{?client_prefix,#[bg=${tertiary}]#[fg=${red}],}'
          set -ga status-left '#[bg=${primary}]#[fg=${secondary}]#{?client_prefix,#[bg=${red}],} #(whoami)@#(hostname) #(uname) #(uname -r) '
          set -ga status-left '#[bg=${tertiary}]#[fg=${primary}]#{?client_prefix,#[bg=${tertiary}]#[fg=${red}],}'
          set -g status-justify absolute-centre
          set-window-option -g window-status-style bg='${secondary},fg=${primary},bold,noreverse'
          set-window-option -g window-status-current-style bg='${primary}',fg='${secondary},bold,noreverse'
          set-window-option -g window-status-activity-style 'bold,noreverse'
          set-window-option -g window-status-bell-style 'bold,noreverse'
          set -g window-status-current-format "#[fg=${primary}]#[bg=${tertiary}]#[fg=${secondary}]#[bg=${primary}] #I #W #[fg=${primary}]#[bg=${tertiary}]"
          set -g window-status-format "#[fg=${secondary}]#[bg=${tertiary}]#{?window_bell_flag,#[bg=${tertiary}]#[fg=${red}],}"
          set -ga window-status-format "#[fg=${primary}]#[bg=${secondary}]#{?window_bell_flag,#[bg=${red}]#[fg=${secondary}],} #I #W "
          set -ga window-status-format "#[bg=${tertiary}]#[fg=${secondary}]#{?window_bell_flag,#[bg=${tertiary}]#[fg=${red}],}"
          set -ga status-right '#[bg=${primary}]#[fg=${secondary}] %a %H:%M:%S %Y-%m-%d #[bg=${tertiary}]#[fg=${primary}]'
        '';
      };
    };
  };
}