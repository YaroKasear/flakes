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
        historyLimit = 5000;
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
          set -g status-right-length 30
          set -g status-left-length 30
          set -g status-style bg='${tertiary}',fg='${primary}'
          set -g status-left '#[bg=${tertiary}]#[fg=${primary}]#{?client_prefix,#[bg=${tertiary}]#[fg=${red}],}'
          set -ga status-left '#[bg=${primary}]#[fg=${secondary}]#{?client_prefix,#[bg=${red}],} #(whoami)@#(hostname) #(uname) #(uname -r) '
          set -ga status-left '#[bg=${tertiary}]#[fg=${primary}]#{?client_prefix,#[bg=${tertiary}]#[fg=${red}],}'
          set -g status-justify absolute-centre
          set-window-option -g window-status-style bg='${secondary},fg=${primary}'
          set-window-option -g window-status-current-style bg='${primary},fg=${secondary}'
          set -g window-status-current-format "#[fg=${primary}]#[bg=${tertiary}]#[fg=${secondary}]#[bg=${primary}] #I #W #[fg=${primary}]#[bg=${tertiary}]"
          set -g window-status-format "#[fg=${secondary}]#[bg=${tertiary}]#[fg=${primary}]#[bg=${secondary}] #I #W #[bg=${tertiary}]#[fg=${secondary}]"
          set -g status-right '#[bg=${tertiary}]#[fg=${primary}]'
          set -ga status-right '#[bg=${primary}]#[fg=${secondary}] %a %H:%M:%S %Y-%m-%d #[bg=${tertiary}]#[fg=${primary}]'
        '';
          # set -g status-style bg='${primary}',fg='${secondary}'
          # set -g status-left '#[bg=${primary}]#[fg=${secondary}]#{?client_prefix,#[bg=${secondary}]#[fg=${primary}],} ☺ '
          # set -ga status-left '#[bg=${primary}]#[fg=${secondary}] #{?window_zoomed_flag, ↕  ,   }'
          # set-window-option -g window-status-style fg='${secondary}',bg=default
          # set-window-option -g window-status-current-style fg='${primary}',bg='${secondary}'
          # set -g window-status-current-format "#[fg=${primary}]#[bg=${secondary}]#[fg=]#[bg=${secondary}] #I #W #[fg=${secondary}]#[bg=${primary}]"
          # set -g window-status-format "#[fg=${tertiary}]#[bg=${primary}]#I #W #[fg=${primary}] "
          # set -g status-right '#[fg=${secondary},bg=${primary}]#[fg=${primary},bg=${secondary}] #(uptime | cut -f 4-6 -d " " | cut -f 1 -d ",") '
          # set -ga status-right '#[fg=${primary},bg=${secondary}] %a %H:%M:%S %Y-%m-%d'
      };
    };
  };
}