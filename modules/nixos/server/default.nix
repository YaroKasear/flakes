{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.server;

in {
  options.united.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "console=tty1"
      "console=ttyS0,115200"
    ];

    united = {
      common = enabled;
      unbound = enabled;
    };

    networking.firewall.allowedUDPPorts = [ 123 ];

    services.ntpd-rs = let
      server-list = ls: map (x: {
        mode = "server";
        address = x;
      }) ls;
    in {
      enable = true;
      # useNetworkingTimeServers = false;
      settings = {
        # source = server-list [
        #   "time1.google.com"
        #   "time2.google.com"
        #   "time3.google.com"
        #   "time4.google.com"
        # ];
        server = [{
          listen = "0.0.0.0:123";
        }];
      };
    };
  };
}