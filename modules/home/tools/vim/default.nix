{ lib, config, ... }:

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
      vim = {
        enable = true;
        defaultEditor = true;
      };
    };
  };
}