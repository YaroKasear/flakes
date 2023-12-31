{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  catppuccin = (pkgs.catppuccin.override { variant = "latte"; });

  cfg = config.united.color.catppuccin.latte;
in {
  options.united.color.catppuccin.latte = {
    enable = mkEnableOption "catppuccin Latte theme!";
  };

  config = mkIf cfg.enable {
    united.color = rec {
      red = "#d20f39";
      green = "#40a02b";
      yellow = "#df8e1d";
      blue = "#1e66f5";

      foreground = extraColors.text;
      background = extraColors.base;

      selection_background = extraColors.surface2;
      selection_foreground = extraColors.text;

      cursor = extraColors.rosewater;
      cursor_text_color = extraColors.base;
      url_color = blue;
      active_tab_foreground = extraColors.surface0;
      active_tab_background = active_border_color;
      active_border_color = extraColors.lavender;
      inactive_tab_foreground = extraColors.text;
      inactive_tab_background = inactive_border_color;
      inactive_border_color = extraColors.overlay0;
      bell_border_color = yellow;

      tab_bar_background = background;
      tab_bar_margin_color = background;

      color0 = extraColors.subtext1;
      color1 = red;
      color2 = green;
      color3 = yellow;
      color4 = blue;
      color5 = extraColors.pink;
      color6 = extraColors.teal;
      color7 = extraColors.surface2;
      color8 = extraColors.subtext0;
      color9 = red;
      color10 = green;
      color11 = yellow;
      color12 = blue;
      color13 = extraColors.pink;
      color14 = extraColors.teal;
      color15 = extraColors.surface1;

      mark1_background = extraColors.lavender;
      mark1_foreground = extraColors.base;
      mark2_background = extraColors.mauve;
      mark2_foreground = extraColors.base;
      mark3_background = extraColors.sapphire;
      mark3_foreground = extraColors.base;

      extraColors = rec {
        base = "#eff1f5";

        crust = "#dce0e8";
        mantle = "#e6e9ef";

        surface0 = "#ccd0da";
        surface1 = "#bcc0cc";
        surface2 = "#acb0be";

        overlay0 = "#9ca0b0";
        overlay1 = "#8c8fa1";
        overlay2 = "#7c7f93";

        text = "#4c4f69";

        subtext0 = "#6c6f85";
        subtext1 = "#5c5f77";

        lavender = "#7287fd";
        maroon = "#e64553";
        mauve = "#8839ef";
        peach = "#fe640b";
        pink = "#ea76cb";
        rosewater = "#dc8a78";
        sapphire = "#209fb5";
        sky = "#04a5e5";
        teal = "#179299";

        color16 = peach;
        color17 = rosewater;

        rainbow_color1 = red;
        rainbow_color2 = peach;
        rainbow_color3 = yellow;
        rainbow_color4 = green;
        rainbow_color5 = sapphire;
        rainbow_color6 = lavender;

        rainbow_color_p1 = "#833255";
        rainbow_color_p2 = "#88684a";
        rainbow_color_p3 = "#45704f";
        rainbow_color_p4 = "#45704f";
        rainbow_color_p5 = "#3757a3";
        rainbow_color_p6 = "#6444a0";
      };
    };

    home.packages = [ catppuccin ];

    programs = {
      btop.settings.color_theme = mkIf config.united.btop.enable "catppuccin_latte";
      cava.settings.color = mkIf config.united.cava.enable {
        gradient = 1;
        gradient_color_1 = "#179299";
        gradient_color_2 = "#04a5e5";
        gradient_color_3 = "#209fb5";
        gradient_color_4 = "#1e66f5";
        gradient_color_5 = "#8839ef";
        gradient_color_6 = "#ea76cb";
        gradient_color_7 = "#e64553";
        gradient_color_8 = "#d20f39";
      };
      fzf.colors = with config.united.color; mkIf config.united.fzf.enable {
        "bg+" = "#ccd0da";
        bg = "#eff1f5";
        spinner = "#dc8a78";
        hl = "#d20f39";
        fg = "#4c4f69";
        header = "#d20f39";
        info = "#8839ef";
        pointer = "#dc8a78";
        marker = "#dc8a78";
        "fg+" = "#4c4f69";
        prompt = "#8839ef";
        "hl+" = "#d20f39";
      };
      tmux = mkIf config.united.tmux.enable {
        plugins = with pkgs; [
          tmuxPlugins.catppuccin
        ];
        extraConfig = mkForce ''
          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
          set -g default-terminal "''${TERM}"
          set -ga terminal-overrides ",xterm-*:Tc"
          bind-key -n Home send Escape "OH"
          bind-key -n End send Escape "OF"
        '';
      };
      nixvim.colorschemes.catppuccin = mkIf config.united.vim.enable {
        enable = true;
        flavour = "frappe";
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
           "workbench.colorTheme" = "Catppuccin Latte";
           "workbench.iconTheme" = "catppuccin-latte";
        };
      };
    };

    xdg.configFile = {
      "btop/themes/catppuccin_frappe.theme" = mkIf config.united.btop.enable {
        source = "${catppuccin}/btop/catppuccin_frappe.theme";
      };
    };
  };
}
