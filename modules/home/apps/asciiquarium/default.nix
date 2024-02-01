{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  home-directory = config.united.user.directories.home;
  smart-wallpaper = (config.united.wayland.enable && config.united.kitty.enable);

  cfg = config.united.asciiquarium;
in {
  options.united.asciiquarium = {
    enable = mkEnableOption "ASCIIquarium";
  };

  config = mkIf cfg.enable {
    home = {
      file."Pictures/Wallpaper/asciiquarium" = mkIf smart-wallpaper {
        source = ./files;
        recursive = true;
      };
      packages = with pkgs; [
        asciiquarium-transparent
      ];
    };

    wayland.windowManager.hyprland = mkIf smart-wallpaper {
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      settings = with config.united.style.colors; {
        exec-once = [
          "kitty --class=\"kitty-bg\" -T _HIDE_ME_ -c ${home-directory}/.config/kitty/asciiquarium.conf asciiquarium"
        ];
      };
      extraConfig = mkDefault ''
        plugin {
          hyprwinwrap {
            class = kitty-bg
            size: 100%;
          }
        }
      '';
    };

    xdg.configFile."kitty/asciiquarium.conf" = mkIf smart-wallpaper {
      text = ''
        background #000000
        background_opacity 0.0
      '';
    };
  };
}