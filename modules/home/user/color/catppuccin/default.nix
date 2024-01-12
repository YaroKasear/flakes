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
    home = {
      packages = with pkgs; [ kitty-themes ];
      file = mkIf config.united.vim.enable {
        ".vim/colors/catppuccin.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin.vim";
      };
    };

    programs = {
      nixvim.colorschemes.catppuccin = mkIf config.united.nixvim.enable {
        enable = true;
      };
      vim = mkIf config.united.vim.enable {
        plugins = [
          pkgs.vimPlugins.catppuccin-vim
        ];
      };
      vscode = mkIf config.united.vscode.enable {
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "catppuccin-vsc";
            publisher = "Catppuccin";
            version = "3.10.1";
            sha256 = "er1ugqZDrw4vLc9luAZ6kkehQ27fSMFQDBjQwmD4D8Q=";
          }
          {
            name = "catppuccin-vsc-icons";
            publisher = "Catppuccin";
            version = "0.33.0";
            sha256 = "UcwaISy0lkBzlrRBZFH/sw2D8EDtKltBWD7xgfAw3U8=";
          }
        ];
        userSettings = {
          "editor.semanticHighlighting.enabled" = true;
          "terminal.integrated.minimumContrastRatio" = 1;
           "window.titleBarStyle" = "custom";
           gopls = {
            "ui.semanticTokens" = true;
          };
        };
      };
      tmux = {
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.catppuccin;
            extraConfig = ''
              set -g @catppuccin_window_left_separator "█"
              set -g @catppuccin_window_right_separator "█ "
              set -g @catppuccin_window_number_position "right"
              set -g @catppuccin_window_middle_separator "  █"

              set -g @catppuccin_window_default_fill "number"

              set -g @catppuccin_window_current_fill "number"
              set -g @catppuccin_window_current_text "#{pane_current_path}"

              set -g @catppuccin_status_modules_right "application session date_time"
              set -g @catppuccin_status_left_separator  ""
              set -g @catppuccin_status_right_separator " "
              set -g @catppuccin_status_right_separator_inverse "yes"
              set -g @catppuccin_status_fill "all"
              set -g @catppuccin_status_connect_separator "no"
            '';
          }
        ];
        extraConfig = ''
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

    xdg.configFile."waybar/catppuccin.css" = mkIf config.united.waybar.enable {
      source = ../files/catppuccin.css;
    };
  };
}
