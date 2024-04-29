{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  home-directory = config.united.user.directories.home;

  cfg = config.united.style.catppuccin.latte;
in {
  options.united.style.catppuccin.latte = {
    enable = mkEnableOption "catppuccin Latte theme!";
  };

  config = mkIf cfg.enable {
    united.style = rec {
      colors = rec {
        red = "#d20f39";
        green = "#40a02b";
        yellow = "#df8e1d";
        blue = "#1e66f5";

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
          rainbow_color_p4 = "#346a7d";
          rainbow_color_p5 = "#3757a3";
          rainbow_color_p6 = "#6444a0";
        };
      };
    };

    home = {
      pointerCursor = mkIf is-linux {
        package = pkgs.catppuccin-cursors.latteBlue;
        name = "Catppuccin-Latte-Dark-Cursors";
        size = 24;
      };
      packages = [
        (pkgs.catppuccin.override { variant = "latte"; })
        (mkIf is-linux pkgs.catppuccin-cursors.latteBlue)
      ];
      file = {
        # mkIf config.united.vim.enable (".vim/colors/latte.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin-latte.vim";);
        # ".vim/colors/latte.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin-latte.vim";
        "${config.united.user.directories.data}/icons/Hyprcatppuccin-Latte-Blue-Cursors".source = "${inputs.hyprcatppuccin-latte-blue}/theme_Extracted Theme";
      };
    };

    gtk = {
      cursorTheme = mkIf is-linux {
        package = pkgs.catppuccin-cursors.latteBlue;
        name = "Catppuccin-Latte-Blue";
        size = 24;
      };
      theme = {
        name = "Catppuccin-Latte-Standard-Blue";
        package = mkIf is-linux (pkgs.catppuccin-gtk.override { variant = "latte"; });
      };
    };

    programs = {
      btop.settings.color_theme = mkIf config.united.btop.enable "catppuccin_latte";
      cava.settings.color = mkIf config.united.cava.enable {
        gradient = 1;
        gradient_color_1 = "'#179299'";
        gradient_color_2 = "'#04a5e5'";
        gradient_color_3 = "'#209fb5'";
        gradient_color_4 = "'#1e66f5'";
        gradient_color_5 = "'#8839ef'";
        gradient_color_6 = "'#ea76cb'";
        gradient_color_7 = "'#e64553'";
        gradient_color_8 = "'#d20f39'";
      };
      fzf.colors = with config.united.style; mkIf config.united.fzf.enable {
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
      oh-my-posh = mkIf config.united.style.catppuccin.latte.enable {
        useTheme = "catppuccin_latte";
      };
      kitty.extraConfig = mkIf config.united.kitty.enable ''
        include ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Latte.conf
      '';
      tmux = mkIf config.united.tmux.enable {
        extraConfig = ''
          source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin-latte.tmuxtheme
        '';
      };
      nixvim.colorschemes.catppuccin = mkIf config.united.nixvim.enable {
        settings.flavour = "latte";
      };
      vim = mkIf config.united.vim.enable {
        extraConfig = ''
          colorscheme catppuccin_latte
        '';
      };
      vscode = mkIf config.united.vscode.enable {
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Frappé";
          "workbench.iconTheme" = "catppuccin-latte";
        };
      };
      waybar.style = mkIf config.united.waybar.enable(mkForce ''
        @import url("latte.css");
        @import url("catppuccin.css");
      '');
      zsh = mkIf config.united.zsh.enable {
        initExtra = "source ${config.united.user.directories.config}/zsh/catppuccin_latte-zsh-syntax-highlighting.zsh";
      };
    };

    united.style.catppuccin.enable = true;

    wayland.windowManager.hyprland = mkIf config.united.hyprland.enable  {
      settings = {
        source = [ "${config.united.user.directories.config}/hypr/latte.conf" ];

        env = [
          "HYPRCURSOR_THEME,Hyprcatppuccin-Latte-Dark-Cursors"
        ];

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

    xdg.configFile = let
      catppuccin = (pkgs.catppuccin.override { variant = "latte"; });
    in {
      "btop/themes/catppuccin_latte.theme" = mkIf config.united.btop.enable {
        source = "${catppuccin}/btop/catppuccin_latte.theme";
      };
      "zsh/catppuccin_latte-zsh-syntax-highlighting.zsh" = mkIf config.united.zsh.enable {
        source = "${inputs.catppuccin-zsh-highlighing}/themes/catppuccin_latte-zsh-syntax-highlighting.zsh";
      };
      "hypr/latte.conf" = mkIf config.united.hyprland.enable {
        source = "${catppuccin}/hyprland/latte.conf";
      };
      "swaync/style.css" = mkIf config.united.hyprland.enable {
        source = "${inputs.catppuccin-swaync-latte}";
      };
      "waybar/latte.css" = mkIf config.united.waybar.enable {
        source = "${catppuccin}/waybar/latte.css";
      };
    };
  };
}
