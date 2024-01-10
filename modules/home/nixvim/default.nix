{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nixvim;
in {
  options.united.nixvim = {
    enable = mkEnableOption "Nixvim";
  };

  config = mkIf cfg.enable {
    programs = {
      nixvim = {
        enable = true;
        defaultEditor = true;
      };
      zsh.shellAliases = {
        nixvim = "nvim";
      };
    };
  };
}