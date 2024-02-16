{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.zoxide;
in {
  options.united.zoxide = {
    enable = mkEnableOption "Zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd cd"
      ];
    };
  };
}