{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nextcloud;
in {
  options.united.nextcloud = {
    enable = mkEnableOption "Nextcloud client!";
  };

  config = mkIf cfg.enable {
    services.nextcloude = {
      enable = true;
      startInBackground = true;
    };
  };
}