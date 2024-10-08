{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  home-directory = config.united.user.directories.home;

  cfg = config.united.style.catppuccin.frappe;
in {
  options.united.style.catppuccin.frappe = {
    enable = mkEnableOption "catppuccin Frappe theme!";
  };

  config = mkIf cfg.enable {
    united.style = rec {
      colors = rec {
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
    };

    home = {
      pointerCursor = mkIf is-linux {
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "Catppuccin-Frappe-Dark-Cursors";
        size = 24;
      };
      packages = [
        (pkgs.catppuccin.override { variant = "frappe"; })
        (mkIf is-linux pkgs.catppuccin-cursors.frappeDark)
        (mkIf config.united.plasma.enable (pkgs.catppuccin-kde.override { flavour = ["frappe"]; }))
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
        package = mkIf is-linux (pkgs.catppuccin-gtk.override { variant = "frappe"; });
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
      fzf.colors = with config.united.style; mkIf config.united.fzf.enable {
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
      oh-my-posh = mkIf config.united.style.catppuccin.frappe.enable {
        useTheme = "catppuccin_frappe";
      };
      kitty.extraConfig = mkIf config.united.kitty.enable ''
        include ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Frappe.conf
        confirm_os_window_close 0
      '';
      tmux = mkIf config.united.tmux.enable {
        extraConfig = ''
          source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin-frappe.tmuxtheme
        '';
      };
      nixvim.colorschemes.catppuccin = mkIf config.united.nixvim.enable {
        settings.flavour = "frappe";
      };
      plasma = {
        configFile = {
          kwinrc."org.kde.kdecoration2"= {
            library = "org.kde.kwin.aurorae";
            NoPlugin = false;
            theme = "__aurorae__svg__CatppuccinFrappe-Modern";
          };
          kcminputrc.Mouse.cursorTheme = "Catppuccin-Frappe-Dark-Cursors";
        };
        workspace.colorScheme = (mkIf config.united.plasma.enable "CatppuccinFrappeBlue");
      };
      vim = mkIf config.united.vim.enable {
        extraConfig = ''
          colorscheme catppuccin_frappe
        '';
      };
      vscode = mkIf config.united.vscode.enable {
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Frappé";
          "workbench.iconTheme" = "catppuccin-frappe";
        };
      };
      zsh = mkIf config.united.zsh.enable {
        initExtra = "source ${config.united.user.directories.config}/zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh";
      };
    };

    united.style.catppuccin = enabled;

    xdg.configFile = let
      catppuccin = (pkgs.catppuccin.override { variant = "frappe"; });
    in {
      "btop/themes/catppuccin_frappe.theme" = mkIf config.united.btop.enable {
        source = "${catppuccin}/btop/catppuccin_frappe.theme";
      };
      "zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh" = mkIf config.united.zsh.enable {
        source = "${inputs.catppuccin-zsh-highlighing}/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh";
      };
    };
  };
}
