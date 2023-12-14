{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.net-utils;
in {
  options.united.net-utils = {
    enable = mkEnableOption "Net-utils";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dig
      ldns
      mtr
      traceroute
    ];
  };
}
