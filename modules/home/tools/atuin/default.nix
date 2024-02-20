{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.atuin;
in {
  options.united.atuin = {
    enable = mkEnableOption "Atuin";
  };

  config = mkIf cfg.enable {
    programs = {
      atuin = {
        enable = true;
        flags = [
          "--disable-up-arrow"
        ];
        settings = {
          sync_address = "http://private.kasear.net:8888";
          sync_frequency = "5m";
        };
      };
    };
  };
}