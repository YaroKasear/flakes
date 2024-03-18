{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.wayfire;

  stringList = lib.concatMapStrings (x: x + " ");
in {
  options.united.wayfire = {
    enable = mkEnableOption "Wayfire";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
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
            "invert"
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
          close-top-view = "<super> KEY_Q | <alt> KEY_F4";
          vwidth = 3;
          vheight = 3;
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
          outputs = "${pkgs.kanshi}/bin/kanshi";
          notifications = "mako";
          gamma = "wlunset";
          idle = "swayidle before-sleep swaylock";
          portal = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
        };
      };
    };

    home.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = 1;
    };

    united.kanshi.enable = true;
  };
}