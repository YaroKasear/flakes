{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  home-directory = config.united.user.directories.home;

  cfg = config.united.style.catppuccin.macchiato;
in {
  options.united.style.catppuccin.macchiato = {
    enable = mkEnableOption "catppuccin Macchiato theme!";
  };

  config = mkIf cfg.enable {
    united.style = rec {
      colors = rec {
        red = "#ed8796";
        green = "#a6da95";
        yellow = "#eed49f";
        blue = "#8aadf4";

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
          base = "#24273a";

          crust = "#181926";
          mantle = "#1e2030";

          surface0 = "#363a4f";
          surface1 = "#494d64";
          surface2 = "#5b6078";

          overlay0 = "#6e738d";
          overlay1 = "#8087a2";
          overlay2 = "#939ab7";

          text = "#cad3f5";

          subtext0 = "#a5adcb";
          subtext1 = "#b7bfdf";

          lavender = "#b7bdf8";
          maroon = "#ee99a0";
          mauve = "#c6a0f6";
          peach = "#f5a97f";
          pink = "#f5bde6";
          rosewater = "#f4dbd6";
          sapphire = "#7dc4e4";
          sky = "#91d7e3";
          teal = "#8bd5ca";

          color16 = peach;
          color17 = rosewater;

          rainbow_color1 = red;
          rainbow_color2 = peach;
          rainbow_color3 = yellow;
          rainbow_color4 = green;
          rainbow_color5 = sapphire;
          rainbow_color6 = lavender;

          rainbow_color_p1 = "#d9b6d0";
          rainbow_color_p2 = "#e3dede";
          rainbow_color_p3 = "#bdd7d0";
          rainbow_color_p4 = "#b2d5e5";
          rainbow_color_p5 = "#b2c5f5";
          rainbow_color_p6 = "#c9c0f5";
        };
      };
    };

    home = {
      pointerCursor = mkIf is-linux {
        package = pkgs.catppuccin-cursors.macchiatoDark;
        name = "Catppuccin-Macchiato-Dark-Cursors";
        size = 24;
      };
      packages = [
        (pkgs.catppuccin.override { variant = "macchiato"; })
        (mkIf is-linux pkgs.catppuccin-cursors.macchiatoDark)
        (mkIf config.united.plasma.enable (pkgs.catppuccin-kde.override { flavour = ["macchiato"]; }))
      ];
      file = {
        # mkIf config.united.vim.enable (".vim/colors/macchiato.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin-macchiato.vim";);
        # ".vim/colors/macchiato.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin-macchiato.vim";
        "${config.united.user.directories.data}/icons/Hyprcatppuccin-Macchiato-Dark-Cursors".source = "${inputs.hyprcatppuccin-macchiato-dark}/theme_Extracted Theme";
      };
    };

    gtk = {
      cursorTheme = mkIf is-linux {
        package = pkgs.catppuccin-cursors.macchiatoDark;
        name = "Catppuccin-Macchiato-Dark";
        size = 24;
      };
      theme = {
        name = "Catppuccin-Macchiato-Standard-Blue-Dark";
        package = mkIf is-linux (pkgs.catppuccin-gtk.override { variant = "macchiato"; });
      };
    };

    programs = {
      btop.settings.color_theme = mkIf config.united.btop.enable "catppuccin_macchiato";
      cava.settings.color = mkIf config.united.cava.enable {
        background = "'#24273a'";
        gradient = 1;
        gradient_color_1 = "'#8bd5ca'";
        gradient_color_2 = "'#91d7e3'";
        gradient_color_3 = "'#7dc4e4'";
        gradient_color_4 = "'#8aadf4'";
        gradient_color_5 = "'#c6a0f6'";
        gradient_color_6 = "'#f5bde6'";
        gradient_color_7 = "'#ee99a0'";
        gradient_color_8 = "'#ed8796'";
      };
      fzf.colors = with config.united.style; mkIf config.united.fzf.enable {
        "bg+" = "#363a4f";
        bg = "#24273a";
        spinner = "#f4dbd6";
        hl = "#ed8796";
        fg = "#cad3f5";
        header = "#ed8796";
        info = "#c6a0f6";
        pointer = "#f4dbd6";
        marker = "#f4dbd6";
        "fg+" = "#cad3f5";
        prompt = "#c6a0f6";
        "hl+" = "#ed8796";
      };
      oh-my-posh = mkIf config.united.style.catppuccin.macchiato.enable {
        useTheme = "catppuccin_macchiato";
      };
      kitty.extraConfig = mkIf config.united.kitty.enable ''
        include ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Macchiato.conf
        confirm_os_window_close 0
      '';
      tmux = mkIf config.united.tmux.enable {
        extraConfig = ''
          source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin-macchiato.tmuxtheme
        '';
      };
      nixvim.colorschemes.catppuccin = mkIf config.united.nixvim.enable {
        settings.flavour = "macchiato";
      };
      plasma.workspace.colorScheme = (mkIf config.united.plasma.enable "CatppuccinMacchiatoBlue");
      vim = mkIf config.united.vim.enable {
        extraConfig = ''
          colorscheme catppuccin_macchiato
        '';
      };
      vscode = mkIf config.united.vscode.enable {
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Macchiato";
          "workbench.iconTheme" = "catppuccin-macchiato";
        };
      };
      waybar.style = mkIf config.united.waybar.enable(mkForce ''
        @import url("macchiato.css");
        @import url("catppuccin.css");
      '');
      zsh = mkIf config.united.zsh.enable {
        initExtra = "source ${config.united.user.directories.config}/zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh";
      };
    };

    united.style.catppuccin = enabled;

    wayland.windowManager.hyprland = mkIf config.united.hyprland.enable  {
      settings = {
        source = [ "${config.united.user.directories.config}/hypr/macchiato.conf" ];

        env = [
          "HYPRCURSOR_THEME,Hyprcatppuccin-Macchiato-Dark-Cursors"
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
      catppuccin = (pkgs.catppuccin.override { variant = "macchiato"; });
    in {
      "btop/themes/catppuccin_macchiato.theme" = mkIf config.united.btop.enable {
        source = "${catppuccin}/btop/catppuccin_macchiato.theme";
      };
      "zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh" = mkIf config.united.zsh.enable {
        source = "${inputs.catppuccin-zsh-highlighing}/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh";
      };
      "hypr/macchiato.conf" = mkIf config.united.hyprland.enable {
        source = "${catppuccin}/hyprland/macchiato.conf";
      };
      "swaync/style.css" = mkIf config.united.hyprland.enable {
        source = "${inputs.catppuccin-swaync-macchiato}";
      };
      "waybar/macchiato.css" = mkIf config.united.waybar.enable {
        source = "${catppuccin}/waybar/macchiato.css";
      };
    };
  };
}
