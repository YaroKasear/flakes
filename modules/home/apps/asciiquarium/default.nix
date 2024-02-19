{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  home-directory = config.united.user.directories.home;
  config-directory = config.united.user.directories.config;

  cfg = config.united.asciiquarium;
in {
  options.united.asciiquarium = {
    enable = mkEnableOption "ASCIIquarium";
    smart-wallpaper = mkEnableOption "Put the asciiquarium on the desktop!";
  };

  config = mkIf cfg.enable {
    home = {
      file."${config.united.user.directories.wallpapers}/asciiquarium" = mkIf (cfg.smart-wallpaper && config.united.wayland.enable) {
        source = ./files;
        recursive = true;
      };
      packages = with pkgs; [
        asciiquarium-transparent
      ];
    };

    wayland.windowManager.hyprland = mkIf (cfg.smart-wallpaper && config.united.wayland.enable) {
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      settings = with config.united.style.colors; {
        exec-once = [
          "kitty --class=\"kitty-bg\" -T _HIDE_ME_ -c ${config-directory}/kitty/asciiquarium.conf asciiquarium"
        ];
      };
      extraConfig = mkDefault ''
        plugin {
          hyprwinwrap {
            class = kitty-bg
            size = 100%
          }
        }
      '';
    };

    xdg.configFile."kitty/asciiquarium.conf" = mkIf (cfg.smart-wallpaper && config.united.wayland.enable) {
      text = ''
        background #000000
        background_opacity 0.0
      '';
    };
  };
}