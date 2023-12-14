{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.kitty;
in {
  options.united.kitty = {
    enable = mkEnableOption "Kitty";
  };

  config = mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        font.name = "FiraCode Nerd Font";
      };
    };

    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };
}