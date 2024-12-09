{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.apache-vikali;

  app = "vikali";
  address = "192.168.1.13";
  dataDir = "/srv/www/root";
  domain = "${app}.kasear.net";
in
{
  options.united.apache-vikali = {
    enable = mkEnableOption "apache-vikali";
  };

  config = mkIf cfg.enable {
    containers."apache-${app}" = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = address;
      config = { ... }: {
        services = {
          httpd = {
            enable = true;
            user = "${app}";
            virtualHosts."${domain}" = {
              adminAddr = "webmaster.vikali@kasear.net";
              documentRoot = dataDir;
              hostName = domain;
              robotsEntries = ''
                User-agent: *
                Disallow: /
              '';
              locations."/".extraConfig = ''
                IndexOptions FancyIndexing FoldersFirst HTMLTable
              '';
              extraConfig = ''
                <IfModule headers_module>
                    #
                    # Avoid passing HTTP_PROXY environment to CGI's on this or any proxied
                    # backend servers which have lingering "httpoxy" defects.
                    # 'Proxy' request header is undefined by the IETF, not listed by IANA
                    #
                    RequestHeader unset Proxy early
                    Header set X-Robots-Tag "noindex, nofollow"
                    RequestHeader set X-Robots-Tag "noindex, nofollow"
                </IfModule>
              '';
            };
          };
        };

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 80 ];
          };
        };

        users = {
          users.${app} = {
            uid = 1002;
            group = app;
            isSystemUser = true;
            home = dataDir;
          };
          groups.${app}.gid = 1002;
        };

        system.stateVersion = "24.05";
      };
      bindMounts."${dataDir}" = {
        hostPath = "/mnt/${domain}";
        isReadOnly = true;
      };
    };

    containers.nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
      host = address;
      port = 80;
      extra-config = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/default/cert.pem";
        sslCertificateKey = "/var/lib/acme/default/key.pem";
      };
    };

    fileSystems."/mnt/${domain}" = {
      device = "storage.kasear.net:/mnt/data/user/vikali/public_html";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

  };
}
