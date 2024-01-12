{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (config.united) user;
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
      path = "$XDG_CONFIG_HOME/blightmud/servers.ron";
      sopsFile = ./secrets.yaml;
    };
  };
}