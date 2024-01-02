{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.kmscon;
in {
  options.united.kmscon = {
    enable = mkEnableOption "Kmscon";
  };

  config = mkIf cfg.enable {
    services = {
      kmscon = {
        enable = true;
        hwRender = true;
        fonts = [
          {
            name = "FiraCode Nerd Font";
            package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
          }
          {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          }
        ];
      };
    };
  };
}