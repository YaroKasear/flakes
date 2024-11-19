{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.headscale;

  app = "vpn";
  address = "192.168.1.19";
  dataDir = "/var/lib/headscale";
  domain = "${app}.kasear.net";
in
{
  options.united.headscale = {
    enable = mkEnableOption "headscale";
  };

  config = mkIf cfg.enable {
    containers.${app} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = address;
      config = { ... }: {

        services = {
          headscale = {
            enable = true;
            settings = {
              server_url = "https://${app}.kasear.net";
              listen_addr = "0.0.0.0:8080";
              metrics_listen_addr = "0.0.0.0:9090";
              ip_prefixes = [ "100.64.0.0/10" ];
              dns_config = {
                base_domain = "mesh.kasear.net";
                nameservers = [
                  "10.10.10.2"
                ];
                override_local_dns = true;
              };
            };
          };
          dnsmasq = {
            enable = true;
            settings = {
              server = [
                "1.1.1.1"
                "1.0.0.1"
              ];
            };
          };
        };

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 8080 ];
        };

        system.stateVersion = "24.05";

        users = {
          users.headscale.uid = 3007;
          groups.headscale.gid = 3009;
        };
      };
      bindMounts.${dataDir} = {
        hostPath = "/mnt/${domain}";
        isReadOnly = false;
      };
    };

    containers.nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy
      {
        host = address;
        port = 8080;
        proxy-web-sockets = true;
        extra-config = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/default/cert.pem";
          sslCertificateKey = "/var/lib/acme/default/key.pem";
        };
      };

    fileSystems."/mnt/${domain}" = {
      device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/${app}";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    users = {
      users.headscale = {
        uid = 3007;
        isSystemUser = true;
        group = "headscale";
      };
      groups.headscale.gid = 3009;
    };
  };
}
