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
        config = {
          sync_address = "https://private.kasear.net";
          sync_frequency = "5m";
        };
      };
    };
  };
}