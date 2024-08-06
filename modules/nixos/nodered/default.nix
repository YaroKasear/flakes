{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nodered;
in {
  options.united.nodered = {
    enable = mkEnableOption "Nodered";
  };

  config = mkIf cfg.enable {
    containers.nodered = {
      autoStart = true;
      config = ../../../containers/nodered/default.nix;
      ephemeral = true;
      bindMounts = {
        "/var/lib/node-red" = {
          hostPath = "/mnt/nodered/user";
          isReadOnly = false;
        };
      };
    };

    fileSystems."/mnt/nodered/user" = {
      device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/nodered/user";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    networking.firewall.allowedTCPPorts = [
      1883
      3456
    ];
  };
}