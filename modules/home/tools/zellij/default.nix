{ lib, config, pkgs, ... }:

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
      zellij = {
        enable = true;
        enableZshIntegration = true;
        settings = {
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
            orange = "${orange}";
          };
        };
      };
    };
  };
}