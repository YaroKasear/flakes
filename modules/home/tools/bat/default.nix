{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.bat;
in {
  options.united.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
      };
      zsh.shellAliases = mkIf config.united.zsh.enable {
        cat = "bat";
      };
    };
  };
}