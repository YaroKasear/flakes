{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
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

    programs = {
      vim.extraConfig = ''
        set termguicolors

        colorscheme catppuccin_latte
      '';
      vscode = {
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "catppuccin-vsc";
            publisher = "Catppuccin";
            version = "3.10.1";
            sha256 = "er1ugqZDrw4vLc9luAZ6kkehQ27fSMFQDBjQwmD4D8Q=";
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
        };
      };
    };

    home.file.".vim/colors".source = "${inputs.catppuccin-vim}/colors";
  };
}
