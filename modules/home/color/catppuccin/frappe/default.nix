{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  catppuccin = (pkgs.catppuccin.override { variant = "frappe"; });
  catppuccin-gtk = mkIf is-linux (pkgs.catppuccin-gtk.override { variant = "frappe"; });
  home-directory = config.united.user.home-directory;
  pictures-directory = "${home-directory}/Pictures";

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

    home = {
      pointerCursor = mkIf is-linux {
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "Catppuccin-Frappe-Dark-Cursors";
        size = 24;
      };
      packages = [
        catppuccin
        pkgs.kitty-themes
        (mkIf is-linux pkgs.catppuccin-cursors.frappeDark)
      ];
    };

    gtk = {
      cursorTheme = mkIf is-linux {
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "Catppuccin-Frappe-Dark";
        size = 24;
      };
      theme = {
        name = "Catppuccin-Frappe-Standard-Blue-Dark";
        package = mkIf is-linux catppuccin-gtk;
      };
    };

    programs = {
      btop.settings.color_theme = mkIf config.united.btop.enable "catppuccin_frappe";
      cava.settings.color = mkIf config.united.cava.enable {
        gradient = 1;
        gradient_color_1 = "'#81c8be'";
        gradient_color_2 = "'#99d1db'";
        gradient_color_3 = "'#85c1dc'";
        gradient_color_4 = "'#8caaee'";
        gradient_color_5 = "'#ca9ee6'";
        gradient_color_6 = "'#f4b8e4'";
        gradient_color_7 = "'#ea999c'";
        gradient_color_8 = "'#e78284'";
      };
      fzf.colors = with config.united.color; mkIf config.united.fzf.enable {
        "bg+" = "#414559";
        bg = "#303446";
        spinner = "#f2d5cf";
        hl = "#e78284";
        fg = "#c6d0f5";
        header = "#e78284";
        info = "#ca9ee6";
        pointer = "#f2d5cf";
        marker = "#f2d5cf";
        "fg+" = "#f2d5cf";
        prompt = "#ca9ee6";
        "hl+" = "#e78284";
      };
      kitty.extraConfig = mkIf config.united.kitty.enable ''
        include ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Frappe.conf
      '';
      tmux = mkIf config.united.tmux.enable {
        extraConfig = ''
          source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin-frappe.tmuxtheme
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
           "workbench.colorTheme" = "Catppuccin Frappé";
           "workbench.iconTheme" = "catppuccin-frappe";
        };
      };
      waybar.style = mkIf config.united.waybar.enable(mkDefault ''
        @import url("frappe.css");
        @import url("catppuccin.css");
      '');
      zsh = mkIf config.united.zsh.enable {
        initExtra = "source ~/.config/zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh";
      };
    };

    united.color.catppuccin.enable = true;

    wayland.windowManager.hyprland = mkIf config.united.hyprland.enable  {
      settings = {
        source = [ "${home-directory}/.config/hypr/frappe.conf" ];

        general = {
          "col.inactive_border" = "$overlay0";
          "col.active_border" = "$lavender";
        };

        group = {
          "col.border_active" = "$lavender";
          "col.border_inactive" = "$overlay0";
          groupbar = {
            "col.active" = "$lavender";
            "col.inactive" = "$overlay0";
          };
        };

        misc = {
          background_color = "$base";
        };
      };
    };

    xdg.configFile = {
      "btop/themes/catppuccin_frappe.theme" = mkIf config.united.btop.enable {
        source = "${catppuccin}/btop/catppuccin_frappe.theme";
      };
      "zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh" = mkIf config.united.zsh.enable {
        source = "${inputs.catppuccin-zsh-highlighing}/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh";
      };
      "hypr/frappe.conf" = mkIf config.united.hyprland.enable {
        source = "${catppuccin}/hyprland/frappe.conf";
      };
      "swaync/style.css" = mkIf config.united.hyprland.enable {
        source = "${inputs.catppuccin-swaync-frappe}";
      };
      "waybar/frappe.css" = mkIf config.united.waybar.enable {
        source = "${catppuccin}/waybar/frappe.css";
      };
      "waybar/catppuccin.css" = mkIf config.united.waybar.enable {
        source = ../files/catppuccin.css;
      };
    };
  };
}
