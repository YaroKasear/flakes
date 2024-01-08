{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.color.catpuccin.latte;
in {
  options.united.color.catpuccin.latte = {
    enable = mkEnableOption "Catpuccin Latte theme!";
  };

  config = mkIf cfg.enable {
  };
}
