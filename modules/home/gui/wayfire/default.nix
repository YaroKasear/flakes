{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayfire;

  home-directory = config.united.user.directories.home;
  screenshots-directory = config.united.user.directories.screenshots;
  wallpapers-directory = config.united.user.directories.wallpapers;

  stringList = lib.concatMapStrings (x: x + " ");
in {
  options.united.wayfire = {
    enable = mkEnableOption "Wayfire";
  };

  config = mkIf cfg.enable {
    xdg.configFile = with config.united.style.colors;
    with inputs.nix-rice.lib.color;
    let
      to-rgba-normal = color:
        let
          rgba = hexToRgba color;
          normalize = component: toString (component / 255.0);
          normalizedR = normalize rgba.r;
          normalizedG = normalize rgba.g;
          normalizedB = normalize rgba.b;
          normalizedA = normalize rgba.a;
        in
          "${normalizedR} ${normalizedG} ${normalizedB} ${normalizedA}";
    in{
      "wayfire.ini".source = (pkgs.formats.ini { }).generate "wayfire.ini" {
        core = {
          plugins = stringList [
            "alpha"
            "animate"
            "autostart"
            "command"
            "cube"
            "decoration"
            "expo"
            "fast-switcher"
            "fisheye"
            "foreign-toplevel"
            "grid"
            "gtk-shell"
            "idle"
            "move"
            "oswitch"
            "place"
            "resize"
            "shortcuts-inhibit"
            "switcher"
            "vswitch"
            "wayfire-shell"
            "window-rules"
            "wm-actions"
            "wobbly"
            "wrot"
            "zoom"
          ];
          close-top-view = "<super> <shift> KEY_Q | <alt> KEY_F4";
          vwidth = 4;
          vheight = 1;
          preferred_decoration_mode = "client";
        };
        move = {
          activate = "<super> BTN_LEFT";
        };
        resize = {
          activate = "<super> BTN_RIGHT";
        };
        zoom = {
          modifier = "<super>";
        };
        alpha = {
          modifier = "<super> <alt>";
        };
        wrot = {
          activate = "<super> <ctrl> BTN_RIGHT";
        };
        fisheye = {
          toggle = "<super> <ctrl> KEY_F";
        };
        autostart = {
          autostart_wf_shell = true;
          outputs = "kanshi";
          notifications = "mako";
          gamma = "wlunset";
          idle = "swayidle before-sleep swaylock";
          portal = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
        };
        command = {
          binding_terminal = "<super> KEY_ENTER";
          command_terminal = "kitty";
          binding_launcher = "<super> KEY_D";
          command_launcher = "wofi --show drun";
          binding_screenshot = "KEY_SYSRQ";
          command_screenshot = "grim ${screenshots-directory}/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png";
          binding_screenshot_interactive = "<shift> KEY_SYSRQ";
          command_screenshot_interactive = "slurp | grim -g - ${screenshots-directory}/$(whoami)-$(hostname)-$(date +'%Y-%m-%d-%H%M%S.png";
          repeatable_binding_volume_up = "KEY_VOLUMEUP";
          command_volume_up = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
          repeatable_binding_volume_down = "KEY_VOLUMEDOWN";
          command_volume_down = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
          binding_mute = "KEY_MUTE";
          command_mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          binding_playpause = "KEY_PLAYPAUSE";
          command_playpause = "playerctl play-pause";
          binding_stop = "KEY_STOPCD";
          command_stop = "playerctl stop";
          binding_previous = "KEY_PREVIOUSSONG";
          command_previous = "playerctl previous";
          binding_next = "KEY_NEXTSONG";
          command_next = "playerctl next";
        };
        grid = {
          slot_bl = "<super> KEY_KP1";
          slot_b = "<super> KEY_KP2";
          slot_br = "<super> KEY_KP3";
          slot_l = "<super> KEY_LEFT | <super> KEY_KP4";
          slot_c = "<super> KEY_UP | <super> KEY_KP5";
          slot_r = "<super> KEY_RIGHT | <super> KEY_KP6";
          slot_tl = "<super> KEY_KP7";
          slot_t = "<super> KEY_KP8";
          slot_tr = "<super> KEY_KP9";
          restore = "<super> KEY_DOWN | <super> KEY_KP0";
        };
        switcher = {
          next_view = "<alt> KEY_TAB";
          prev_view = "<alt> <shift> KEY_TAB";
        };
        fast-switcher = {
          activate = "<alt> KEY_ESC";
        };
        vswitch = {
          binding_left = "<ctrl> <super> KEY_LEFT";
          binding_down = "<ctrl> <super> KEY_DOWN";
          binding_up = "<ctrl> <super> KEY_UP";
          binding_right = "<ctrl> <super> KEY_RIGHT";
          with_win_left = "<ctrl> <super> <shift> KEY_LEFT";
          with_win_down = "<ctrl> <super> <shift> KEY_DOWN";
          with_win_up = "<ctrl> <super> <shift> KEY_UP";
          with_win_right = "<ctrl> <super> <shift> KEY_RIGHT";
        };
        cube = {
          activate = "<ctrl> <alt> BTN_LEFT";
          rotate_left = "<ctrl> <alt> KEY_LEFT";
          rotate_right = "<ctrl> <alt> KEY_RIGHT";
          background = "${to-rgba-normal background}";
        };
        expo = {
          toggle = "<super> KEY_E";
          select_workspace_1 = "KEY_1";
          select_workspace_2 = "KEY_2";
          select_workspace_3 = "KEY_3";
          select_workspace_4 = "KEY_4";
          select_workspace_5 = "KEY_5";
          select_workspace_6 = "KEY_6";
          select_workspace_7 = "KEY_7";
          select_workspace_8 = "KEY_8";
          select_workspace_9 = "KEY_9";
        };
        wayfire-shell = {
          toggle-menu = "<super>";
        };
      };
    };

    home = {
      sessionVariables.WLR_NO_HARDWARE_CURSORS = 1;

      packages = with pkgs; [
        grim
        slurp
      ];
    };

    programs.wofi.enable = true;

    united.kanshi.enable = true;
  };
}