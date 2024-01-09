{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  catppuccin = (pkgs.catppuccin.override { variant = "frappe"; });
  catppuccin-gtk = (pkgs.catppuccin-gtk.override { variant = "frappe"; });
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
      pointerCursor = {
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "Catppuccin-Frappe-Dark-Cursors";
        size = 24;
      };
      packages = [
        catppuccin
        pkgs.kitty-themes
        pkgs.catppuccin-cursors.frappeDark
      ];
    };

    gtk = {
      cursorTheme = {
        package = pkgs.catppuccin-cursors.frappeDark;
        name = "Catppuccin-Frappe-Dark";
        size = 24;
      };
      theme = {
        name = "Catppuccin-Frappe-Standard-Blue-Dark";
        package = catppuccin-gtk;
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
      zsh = mkIf config.united.zsh.enable {
        initExtra = "source ~/.config/zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh";
      };
    };

    united.color.catppuccin.enable = true;

    wayland.windowManager.hyprland = mkIf config.united.hyprland.enable  {
      settings = mkForce {
        source = [ "${home-directory}/.config/hypr/frappe.conf" ];

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "swaync"
          "waybar"
          "wallpaper-generator `ls ${inputs.wallpaper-generator.packages.x86_64-linux.wp-gen}/bin/generators | grep .lua | shuf -n 1 | cut -d . -f 1` -o /tmp/background.png --width 2560 --height 1440 && hyprpaper"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "kitty --class=\"kitty-bg\" asciiquarium"
        ];

        monitor = ",highrr,auto,auto";
        "$terminal" = "kitty";
        "$menu" = "wofi --show drun";

        env = [
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "GBM_BACKEND,nvidia-drm"
          "LIBVA_DRIVER_NAME,nvidia"
          "QT_QPA_PLATFORMTHEME,qt5ct"
          "WLR_NO_HARDWARE_CURSORS,1"
          "WLR_DRM_NO_ATOMIC,1"
          "XCURSOR_SIZE,24"
          "XDG_CURRENT_DESKTOP=Hyprland"
          "XDG_SESSION_DESKTOP=Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "__GL_GSYNC_ALLOWED,1"
        ];

        input = {
          numlock_by_default = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.inactive_border" = "$overlay0";
          "col.active_border" = "$lavender";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true;
        };

        group = {
          "col.border_active" = "$lavender";
          "col.border_inactive" = "$overlay0";
          groupbar = {
            "col.active" = "$lavender";
            "col.inactive" = "$overlay0";
            font_family = "FiraCode Nerd Font";
            font_size = 10;
            gradients = true;
            render_titles = true;
          };
        };

        decoration = {
          rounding = 10;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
        };

        dwindle = {
          smart_split = true;
          smart_resizing = true;
        };

        master = {
          allow_small_split = true;
          new_is_master = false;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        misc = {
          background_color = "$base";
          disable_hyprland_logo = true;
          vrr = 2;
        };

        windowrulev2 = [
          "nomaximizerequest, class:.*"
          "float, title:^(Picture-in-Picture)$"
          "size 800 450, title:(Picture-in-Picture)"
          "pin, title:^(Picture-in-Picture)$"
          "float, title:^(Firefox)$"
          "size 800 450, title:(Firefox)"
          "pin, title:^(Firefox)"
          "immediate, class:^(cs2)$"
          "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
        ];

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, Q, exec, $terminal"
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod, E, togglegroup,"
          "$mainMod, code:65, togglefloating,"
          "$mainMod SHIFT, code:65, pin,"
          "$mainMod SHIFT, N, exec, swanc-client -t sw"
          "$mainMod, D, exec, $menu"
          "$mainMod, F, fullscreen,"
          "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          "$mainMod SHIFT, P, exec, hyprpicker | wl-copy"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, left, swapnext, prev"
          "$mainMod SHIFT, right, swapnext,"
          ",Print,exec,grim ${pictures-directory}/Screenshots/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png')"
          "SHIFT,Print,exec,slurp | grim -g - ${pictures-directory}/Screenshots/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png')"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
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
    };
  };
}
