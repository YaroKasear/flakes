{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.polybar;
in {
  options.united.polybar = {
    enable = mkEnableOption "Polybar";
  };

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        alsaSupport = false;
        pulseSupport = true;
        i3Support = true;
      };
      script = ''
        polybar top &
        polybar bottom &
      '';
      settings = {
        "bar/top" = {
          bottom = false;
          fixed-center = true;
          font = [
            "FiraCode Nerd Font:style=Regular"
            "Noto Color Emoji:scale=10:style=Regular"
          ];
          dpi = 0;
          modules-left = "player-mpris-tail";
          modules-right = "pulseaudio";
          pseudo-transparency = true;
        };
        "bar/bottom" = {
          bottom = true;
          enable-ipc = true;
          fixed-center = true;
          height = 30;
          font = [
            "FiraCode Nerd Font:style=Regular"
            "Noto Color Emoji:scale=10:style=Regular"
          ];
          dpi = 0;
          pseudo-transparency = true;
          modules-left = "i3wsm-groups i3wsm-workspaces i3wsm-toggle-hidden i3wsm";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          interval = 5;
          format-volume = "<label-volume> <ramp-volume> <bar-volume> ";
          format-muted = "<ramp-volume> <bar-volume> ";
          format-muted-prefix = "🔇 ";
          bar-volume-width = 10;
          bar-volume-indicator = "|";
          bar-volume-fill = "─";
          bar-volume-empty = "─";
          ramp-volume = [
            "🔈"
            "🔉"
            "🔊"
          ];
          use-ui-volume = true;
        };
        "module/player-mpris-tail" = {
          type = "custom/script";
          exec = "~/.config/polybar/player-mpris-tail.py -f '{artist} - {title}'";
          tail = true;
        };
        "module/i3wsm" = {
          type = "custom/ipc";
          hook = [
            "${pkgs.united.i3-wsman}/bin/i3-wsman polybar"
          ];
        };
        "module/i3wsm-groups" = {
          type = "custom/ipc";
          hook = [
            "${pkgs.united.i3-wsman}/bin/i3-wsman polybar module-groups"
          ];
          initial = 1;
          format = "<label>";
          format-font = 1;
        };
        "module/i3wsm-toggle-hidden" = {
          type = "custom/ipc";
          hook = [
            "${pkgs.united.i3-wsman}/bin/i3-wsman polybar module-toggle-hidden"
          ];
          initial = 1;
          format = "<label>";
          format-font = 1;
        };
        "module/i3wsm-workspaces" = {
          type = "custom/ipc";
          hook = [
            "${pkgs.united.i3-wsman}/bin/i3-wsman polybar module-workspaces"
          ];
          initial = 1;
          format = "<label>";
          format-font = 1;
        };
      };
    };

    home.file = {
      player-mpris-tail = {
        executable = true;
        source = ../../../files/polybar/player-mpris-tail.py;
        target = ".config/polybar/player-mpris-tail.py";
      };
      i3-wsman-polybar = {
        source = ../../../files/polybar/i3-wsman.ini;
        target = ".config/polybar/i3-wsman.ini";
      };
    };
  };
}