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

    services.ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = false;
      settings = {
        source = [
          {
            mode = "server";
            address = "time-a-g.nist.gov";
          }
          {
            mode = "server";
            address = "time-b-g.nist.gov";
          }
          {
            mode = "server";
            address = "time-c-g.nist.gov";
          }
          {
            mode = "server";
            address = "time-d-g.nist.gov";
          }
          {
            mode = "server";
            address = "time-a-wwv.nist.gov";
          }
          {
            mode = "server";
            address = "time-b-wwv.nist.gov";
          }
          {
            mode = "server";
            address = "time-c-wwv.nist.gov";
          }
          {
            mode = "server";
            address = "time-d-wwv.nist.gov";
          }
          {
            mode = "server";
            address = "time-a-b.nist.gov";
          }
          {
            mode = "server";
            address = "time-b-b.nist.gov";
          }
          {
            mode = "server";
            address = "time-c-b.nist.gov";
          }
          {
            mode = "server";
            address = "time-d-b.nist.gov";
          }
          {
            mode = "server";
            address = "time.nist.gov";
          }
          {
            mode = "server";
            address = "time-e-b.nist.gov";
          }
          {
            mode = "server";
            address = "time-e-g.nist.gov";
          }
          {
            mode = "server";
            address = "time-e-wwv.nist.gov";
          }
          {
            mode = "server";
            address = "utcnist.colorado.edu";
          }
          {
            mode = "server";
            address = "utcnist2.colorado.edu";
          }
        ];
        server = [{
          listen = "0.0.0.0:123";
        }];
      };
    };
  };
}