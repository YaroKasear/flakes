{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.obsidian;
in {
  options.united.obsidian = {
    enable = mkEnableOption "Obsidian!";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.obsidian];
  };
}