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
    home = {
      packages = with pkgs; [
        delta
        entr
      ];
      sessionVariables = {
        BATDIFF_USE_DELTA = "true";
      };
    };

    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batwatch
        ];
      };
      zsh.shellAliases = mkIf config.united.zsh.enable {
        cat = "bat";
        diff = "batdiff";
        man = "batman";
        watch = "batwatch -x";
      };
    };
  };
}