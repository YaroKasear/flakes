{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

  cfg = config.united.zellij;
in {
  options.united.zellij = {
    enable = mkEnableOption "Zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      settings = let
        averageColor = color1: color2: (
        let
          color1Rgba = inputs.nix-rice.lib.color.hexToRgba color1;
          color2Rgba = inputs.nix-rice.lib.color.hexToRgba color2;
        in inputs.nix-rice.lib.color.toRgbHex {
          r = ((color1Rgba.r + color2Rgba.r) / 2);
          g = ((color1Rgba.g + color2Rgba.g) / 2);
          b = ((color1Rgba.b + color2Rgba.b) / 2);
          a = 1;
        });
      in {
        themes.default = with config.united.style.colors; {
          fg = "${foreground}";
          bg = "${background}";
          black = "${black}";
          red = "${red}";
          green = "${green}";
          yellow = "${yellow}";
          blue = "${blue}";
          magenta = "${magenta}";
          cyan = "${cyan}";
          white = "${white}";
          orange = "${averageColor red yellow}";
        };
        ui.pane_frames.rounded_corners = true;
      };
    };
  };
}