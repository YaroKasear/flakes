{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.asciiquarium;
in {
  options.united.asciiquarium = {
    enable = mkEnableOption "ASCIIquarium";
  };

  config = mkIf cfg.enable {
    home = {
      file."Pictures/Wallpaper" = {
        source = ./files;
        recursive = true;
      };
      packages = with pkgs; [
        asciiquarium-transparent
      ];
    };

    wayland.windowManager.hyprland = mkIf config.united.wayland.enable {
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      ];
      settings = with config.united.style.colors; {
        exec-once = [
          "kitty --class=\"kitty-bg\" -T _HIDE_ME_ -c ${home-directory}/.config/kitty/asciiquarium.conf asciiquarium"
        ];

        extraConfig = mkDefault ''
          plugin {
            hyprwinwrap {
              class = kitty-bg
              size: 100%;
            }
          }
        '';
      };
    };

    xdg.configFile."kitty/asciiquarium.conf" = mkIf config.united.kitty.enable {
      text = ''
        background #000000
        background_opacity 0.0
      '';
    };
  };
}