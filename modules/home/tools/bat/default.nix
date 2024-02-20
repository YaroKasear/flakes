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
    home.packages = with pkgs; [
      entr
    ];

    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batman
          batwatch
        ];
      };
      zsh.shellAliases = mkIf config.united.zsh.enable {
        cat = "bat";
        man = "batman";
        watch = "batwatch";
      };
    };
  };
}