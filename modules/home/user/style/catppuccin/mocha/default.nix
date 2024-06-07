{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  home-directory = config.united.user.directories.home;

  cfg = config.united.style.catppuccin.mocha;
in {
  options.united.style.catppuccin.mocha = {
    enable = mkEnableOption "catppuccin Mocha theme!";
  };

  config = mkIf cfg.enable {
    united.style = rec {
      colors = rec {
        red = "#f38ba8";
        green = "#a6e3a1";
        yellow = "#f9e2af";
        blue = "#89b4fa";

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
          base = "#1e1e2e";

          crust = "#10101a";
          mantle = "#181825";

          surface0 = "#313244";
          surface1 = "#45475a";
          surface2 = "#575a6f";

          overlay0 = "#6c7086";
          overlay1 = "#7f849c";
          overlay2 = "#9399b2";

          text = "#cdd6f4";

          subtext0 = "#a6adc8";
          subtext1 = "#bac2de";

          lavender = "#b4befe";
          maroon = "#eba0ac";
          mauve = "#cba6f7";
          peach = "#fab387";
          pink = "#f5c2e7";
          rosewater = "#f5e0dc";
          sapphire = "#74c7ec";
          sky = "#89dceb";
          teal = "#94e2d5";

          color16 = peach;
          color17 = rosewater;

          rainbow_color1 = red;
          rainbow_color2 = peach;
          rainbow_color3 = yellow;
          rainbow_color4 = green;
          rainbow_color5 = sapphire;
          rainbow_color6 = lavender;

          rainbow_color_p1 = "#ddb9d7";
          rainbow_color_p2 = "#dfdbd8";
          rainbow_color_p3 = "#bedcd4";
          rainbow_color_p4 = "#b6dbe8";
          rainbow_color_p5 = "#b3c9f6";
          rainbow_color_p6 = "#cdc4f5";
        };
      };
    };

    home = {
      pointerCursor = mkIf is-linux {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "Catppuccin-Mocha-Dark-Cursors";
        size = 24;
      };
      packages = [
        (pkgs.catppuccin.override { variant = "mocha"; })
        (mkIf is-linux pkgs.catppuccin-cursors.mochaDark)
        (mkIf config.united.plasma.enable (pkgs.catppuccin-kde.override { flavour = ["mocha"]; }))
      ];
      file = {
        # mkIf config.united.vim.enable (".vim/colors/mocha.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin-mocha.vim";);
        # ".vim/colors/mocha.vim".source = "${pkgs.vimPlugins.catppuccin-vim}/colors/catppuccin-mocha.vim";
        "${config.united.user.directories.data}/icons/Hyprcatppuccin-Mocha-Dark-Cursors".source = "${inputs.hyprcatppuccin-mocha-dark}/theme_Extracted Theme";
      };
    };

    gtk = {
      cursorTheme = mkIf is-linux {
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "Catppuccin-Mocha-Dark";
        size = 24;
      };
      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-Dark";
        package = mkIf is-linux (pkgs.catppuccin-gtk.override { variant = "mocha"; });
      };
    };

    programs = {
      btop.settings.color_theme = mkIf config.united.btop.enable "catppuccin_mocha";
      cava.settings.color = mkIf config.united.cava.enable {
        background = "'#1e1e2e'";
        gradient = 1;
        gradient_color_1 = "'#94e2d5'";
        gradient_color_2 = "'#89dceb'";
        gradient_color_3 = "'#74c7ec'";
        gradient_color_4 = "'#89b4fa'";
        gradient_color_5 = "'#cba6f7'";
        gradient_color_6 = "'#f5c2e7'";
        gradient_color_7 = "'#eba0ac'";
        gradient_color_8 = "'#f38ba8'";
      };
      fzf.colors = with config.united.style; mkIf config.united.fzf.enable {
        "bg+" = "#313244";
        bg = "#1e1e2e";
        spinner = "#f5e0dc";
        hl = "#f38ba8";
        fg = "#cdd6f4";
        header = "#f38ba8";
        info = "#cba6f7";
        pointer = "#f5e0dc";
        marker = "#f5e0dc";
        "fg+" = "#cdd6f4";
        prompt = "#cba6f7";
        "hl+" = "#f38ba8";
      };
      oh-my-posh = mkIf config.united.style.catppuccin.mocha.enable {
        useTheme = "catppuccin_mocha";
      };
      kitty.extraConfig = mkIf config.united.kitty.enable ''
        include ${pkgs.kitty-themes}/share/kitty-themes/themes/Catppuccin-Mocha.conf
        confirm_os_window_close 0
      '';
      tmux = mkIf config.united.tmux.enable {
        extraConfig = ''
          source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin-mocha.tmuxtheme
        '';
      };
      nixvim.colorschemes.catppuccin = mkIf config.united.nixvim.enable {
        settings.flavour = "mocha";
      };
      vim = mkIf config.united.vim.enable {
        extraConfig = ''
          colorscheme catppuccin_mocha
        '';
      };
      vscode = mkIf config.united.vscode.enable {
        userSettings = {
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
        };
      };
      waybar.style = mkIf config.united.waybar.enable(mkForce ''
        @import url("mocha.css");
        @import url("catppuccin.css");
      '');
      zsh = mkIf config.united.zsh.enable {
        initExtra = "source ${config.united.user.directories.config}/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh";
      };
    };

    united.style.catppuccin = enabled;

    wayland.windowManager.hyprland = mkIf config.united.hyprland.enable  {
      settings = {
        source = [ "${config.united.user.directories.config}/hypr/mocha.conf" ];

        env = [
          "HYPRCURSOR_THEME,Hyprcatppuccin-Mocha-Dark-Cursors"
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
      catppuccin = (pkgs.catppuccin.override { variant = "mocha"; });
    in {
      "btop/themes/catppuccin_mocha.theme" = mkIf config.united.btop.enable {
        source = "${catppuccin}/btop/catppuccin_mocha.theme";
      };
      "zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh" = mkIf config.united.zsh.enable {
        source = "${inputs.catppuccin-zsh-highlighing}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
      };
      "hypr/mocha.conf" = mkIf config.united.hyprland.enable {
        source = "${catppuccin}/hyprland/mocha.conf";
      };
      "swaync/style.css" = mkIf config.united.hyprland.enable {
        source = "${inputs.catppuccin-swaync-mocha}";
      };
      "waybar/mocha.css" = mkIf config.united.waybar.enable {
        source = "${catppuccin}/waybar/mocha.css";
      };
    };
  };
}
