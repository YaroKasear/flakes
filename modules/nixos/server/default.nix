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

    services.ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = false;
      settings = {
        source = [
          {
            mode = "pool";
            address = "time.nist.gov";
          }
          {
            mode = "pool";
            address = "us.pool.ntp.org";
          }
          {
            mode = "pool";
            address = "time.cloudflare.com";
          }
        ];
        server = [{
          listen = "0.0.0.0:123";
        }];
      };
    };
  };
}