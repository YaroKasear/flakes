{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.style.catppuccin;

in {
  options.united.style.catppuccin = {
    enable = mkEnableOption "Default settings not to be overridden by Catppuccin themes.";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (mkIf config.united.kitty.enable kitty-themes)
        (mkIf config.united.plasma.enable catppuccin-kde)
      ];
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
            publisher = "catppuccin";
            version = "3.14.0";
            sha256 = "066wsdjck2aq7gznl772ymkw5rd52mc0imkjw52m4x11b13hbm4h";
          }
          {
            name = "catppuccin-vsc-icons";
            publisher = "catppuccin";
            version = "1.13.0";
            sha256 = "0baygqdjxca7igk5paqi45ls4szvvhc9890aaaxvcdqw8fain2z2";
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
          bind r source-file ${config.united.user.directories.config}/tmux/tmux.conf \; display "Reloaded!"
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
        confirm_os_window_close 0
        enable_audio_bell yes
        window_alert_on_bell yes
        bell_on_tab "🔔 "
        bell_path ${config.united.user.directories.data}/sound/bell.oga
        background_opacity 0.8
        background_blur 32
        tab_bar_min_tabs 2

        font_features ${config.united.style.fonts.terminal.name} +cv02 +cv05 +cv09 +cv14 +ss04 +cv16 +cv31 +cv25 +cv26 +cv32 +cv28 +ss10 +zero +onum
        tab_bar_edge                bottom
        tab_bar_style               powerline
        tab_powerline_style         slanted
        tab_title_template          {title}{' :{}:'.format(num_windows) if num_windows > 1 else \'\'}
      '';
    };
  };
}
