{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.gnupg;
in {
  options.united.gnupg = {
    enable = mkEnableOption "Gnupg";
  };

  config = mkIf cfg.enable {
    programs .gpg.enable = true;
  };
}