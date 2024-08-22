{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.home-assistant;
in {
  options.united.home-assistant = {
    enable = mkEnableOption "home-assistant";
  };

  config = mkIf cfg.enable {
    containers.hass = {
      autoStart = true;
      config = ../../../containers/home-assistant/default.nix;
            bindMounts = {
        "/etc/hass" = {
          hostPath = "/mnt/home-assistant/config";
          isReadOnly = false;
        };
      };
    };

    fileSystems."/mnt/home-assistant/config" = {
      device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/home-assistant/config";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}