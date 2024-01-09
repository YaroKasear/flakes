{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.vim;
in {
  options.united.vim = {
    enable = mkEnableOption "Vim";
  };

  config = mkIf cfg.enable {
    programs = {
      nixvim = {
        enable = true;
        defaultEditor = true;
      };
    };
  };
}