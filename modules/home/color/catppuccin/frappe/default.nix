{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.color.catppuccin.frappe;
in {
  options.united.color.catppuccin.frappe = {
    enable = mkEnableOption "catppuccin Frappe theme!";
  };

  config = mkIf cfg.enable {
    united.color = rec {
      red = "#e78284";
      green = "#a6d189";
      yellow = "#e5c890";
      blue = "#8caaee";

      foreground = extraColors.text;
      background = extraColors.base;

      selection_background = extraColors.surface2;
      selection_foreground = extraColors.text;

      cursor = extraColors.rosewater;
      cursor_text_color = extraColors.crust;
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

      color0 = extraColors.surface1;
      color1 = red;
      color2 = green;
      color3 = yellow;
      color4 = blue;
      color5 = extraColors.pink;
      color6 = extraColors.teal;
      color7 = extraColors.subtext1;
      color8 = extraColors.surface2;
      color9 = red;
      color10 = green;
      color11 = yellow;
      color12 = blue;
      color13 = extraColors.pink;
      color14 = extraColors.teal;
      color15 = extraColors.subtext0;

      mark1_background = extraColors.lavender;
      mark1_foreground = extraColors.crust;
      mark2_background = extraColors.mauve;
      mark2_foreground = extraColors.crust;
      mark3_background = extraColors.sapphire;
      mark3_foreground = extraColors.crust;

      extraColors = rec {
        base = "#303446";

        crust = "#232634";
        mantle = "#292c3c";

        surface0 = "#414559";
        surface1 = "#51576d";
        surface2 = "#626880";

        overlay0 = "#737994";
        overlay1 = "#838ba7";
        overlay2 = "#949cbb";

        text = "#c6d0f5";

        subtext0 = "#a5adce";
        subtext1 = "#b5bfe2";

        lavender = "#babbf1";
        maroon = "#ea999c";
        mauve = "#ca9ee6";
        peach = "#ef9f76";
        pink = "#f4b8e4";
        rosewater = "#f2d5cf";
        sapphire = "#f2d5cf";
        sky = "#99d1db";
        teal = "#81c8be";

        color16 = peach;
        color17 = rosewater;

        rainbow_color1 = red;
        rainbow_color2 = peach;
        rainbow_color3 = yellow;
        rainbow_color4 = green;
        rainbow_color5 = sapphire;
        rainbow_color6 = lavender;

        rainbow_color_p1 = "#d4b3c9";
        rainbow_color_p2 = "#d3cece";
        rainbow_color_p3 = "#bad1cb";
        rainbow_color_p4 = "#accee0";
        rainbow_color_p5 = "#b1c2f2";
        rainbow_color_p6 = "#c9bdf0";
      };
    };

    programs = {
      vim.extraConfig = ''
        set termguicolors

        colorscheme catppuccin_frappe
      '';
      vscode = {
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
           "workbench.colorTheme" = "Catppuccin Frappé";
           "workbench.iconTheme" = "catppuccin-frappe";
        };
      };
    };

    home.file.".vim/colors".source = "${inputs.catppuccin-vim}/colors";
  };
}
