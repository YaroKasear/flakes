{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nginx-default;

  app = "default";
  address = "192.168.1.12";
  dataDir = "/srv/www/root";
  domain = "${app}.kasear.net";
in
{
  options.united.nginx-default = {
    enable = mkEnableOption "nginx-default";
  };

  config = mkIf cfg.enable {
    containers = {
      "nginx-${app}" = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.1";
        localAddress = address;

        config = { pkgs, ... }:
          {
            services = {
              nginx = {
                enable = true;
                recommendedOptimisation = true;
                virtualHosts."_".locations = {
                  "/" = {
                    root = dataDir;
                  };
                };
              };
            };

            networking = {
              firewall = {
                enable = true;
                allowedTCPPorts = [ 80 ];
              };
            };

            system.stateVersion = "25.05";
          };

        bindMounts = {
          "/srv/www/root" = {
            hostPath = "/mnt/${domain}/data";
            isReadOnly = true;
          };
        };
      };

      nginx-proxy.config.services.nginx.virtualHosts."_" = network.create-proxy {
        port = 80;
        host = address;
        extra-config = {
          default = true;
          forceSSL = true;
          sslCertificate = "/var/lib/acme/default/cert.pem";
          sslCertificateKey = "/var/lib/acme/default/key.pem";
        };
      };
    };

    fileSystems."/mnt/${domain}/data" = {
      device = "storage.kasear.net:/mnt/data/containers/nginx/default";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };
  };
}
