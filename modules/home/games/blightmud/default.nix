{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.blightmud;

in
  {
  options.united.blightmud = {
    enable = mkEnableOption "Blightmud";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [
        blightmud
      ];
    };

    sops.secrets.servers = mkIf config.united.sops.enable {
      path = "${config.united.user.directories.config}/blightmud/servers.ron";
      sopsFile = ./secrets.yaml;
    };
  };
}