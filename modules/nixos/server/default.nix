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

    services.openntpd = {
      enable = true;
      servers = [
        "time.nist.gov"
        "us.pool.ntp.org"
        "time.cloudflare.com"
      ];
    };

    # services.ntpd-rs = {
    #   enable = true;
    #   useNetworkingTimeServers = false;
    #   settings = {
    #     source = [
    #       {
    #         mode = "server";
    #         address = "us.pool.ntp.org";
    #       }
    #       {
    #         mode = "server";
    #         address = "time.cloudflare.com";
    #       }
    #     ];
    #     server = [{
    #       listen = "0.0.0.0:123";
    #     }];
    #   };
    # };
  };
}