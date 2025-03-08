{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nextcloud;
  secrets-directory = inputs.self + "/secrets/modules/${app}/";

  app = "cloud";
  address = "192.168.1.17";
  dataDir = "/var/lib/nextcloud";
  domain = "${app}.kasear.net";
in
{
  options.united.nextcloud = {
    enable = mkEnableOption "nextcloud";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      "admin-password" = {
        rekeyFile = secrets-directory + "admin-password.age";
        path = "/var/admin-password";
        owner = app;
        mode = "400";
        symlink = false;
      };
      "secrets.json" = {
        rekeyFile = secrets-directory + "secrets.json.age";
        path = "/var/secrets.json";
        owner = app;
        mode = "400";
        symlink = false;
      };
    };

    containers = {
      "${app}" = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.1";
        localAddress = address;
        timeoutStartSec = "0";

        config = { pkgs, ... }:
          {
            services = {
              nextcloud = {
                enable = true;
                hostName = domain;
                https = true;
                database.createLocally = true;
                maxUploadSize = "10G";
                settings = {
                  default_phone_region = "US";
                  log_type = "file";
                  maintenance_window_start = 1;
                  overwritehost = "cloud.kasear.net";
                  overwriteprotocol = "https";
                  "overwrite.cli.url" = "https://cloud.kasear.net";
                  trusted_domains = [ "kasear.net" ];
                  trusted_proxies = [
                    "10.0.10.1/32"
                    "173.245.48.0/20"
                    "103.21.244.0/22"
                    "103.22.200.0/22"
                    "103.31.4.0/22"
                    "141.101.64.0/18"
                    "108.162.192.0/18"
                    "190.93.240.0/20"
                    "188.114.96.0/20"
                    "197.234.240.0/22"
                    "198.41.128.0/17"
                    "162.158.0.0/15"
                    "104.16.0.0/13"
                    "104.24.0.0/14"
                    "172.64.0.0/13"
                    "131.0.72.0/22"
                    "169.254.0.0/16"
                    "2400:cb00::/32"
                    "2606:4700::/32"
                    "2803:f800::/32"
                    "2405:b500::/32"
                    "2405:8100::/32"
                    "2a06:98c0::/29"
                    "2c0f:f248::/32"
                  ];
                };
                secretFile = "/var/secrets.json";
                configureRedis = true;
                config = {
                  adminuser = "admin";
                  adminpassFile = "/var/admin-password";
                  dbtype = "mysql";
                };
                phpOptions."opcache.interned_strings_buffer" = 16;
              };
              nginx.virtualHosts.${domain}.extraConfig = ''
                set_real_ip_from 173.245.48.0/20;
                set_real_ip_from 103.21.244.0/22;
                set_real_ip_from 103.22.200.0/22;
                set_real_ip_from 103.31.4.0/22;
                set_real_ip_from 141.101.64.0/18;
                set_real_ip_from 108.162.192.0/18;
                set_real_ip_from 190.93.240.0/20;
                set_real_ip_from 188.114.96.0/20;
                set_real_ip_from 197.234.240.0/22;
                set_real_ip_from 198.41.128.0/17;
                set_real_ip_from 162.158.0.0/15;
                set_real_ip_from 104.16.0.0/13;
                set_real_ip_from 104.24.0.0/14;
                set_real_ip_from 172.64.0.0/13;
                set_real_ip_from 131.0.72.0/22;
                set_real_ip_from 169.254.0.0/16;
                set_real_ip_from 2400:cb00::/32;
                set_real_ip_from 2606:4700::/32;
                set_real_ip_from 2803:f800::/32;
                set_real_ip_from 2405:b500::/32;
                set_real_ip_from 2405:8100::/32;
                set_real_ip_from 2a06:98c0::/29;
                set_real_ip_from 2c0f:f248::/32;
                real_ip_header X-Forwarded-For;
                real_ip_recursive on;
                client_body_buffer_size 400M;
              '';
              dnsmasq = {
                enable = mkDefault true;
                settings = {
                  server = [
                    "1.1.1.1"
                    "1.0.0.1"
                  ];
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
              users.nextcloud.uid = 3003;
              groups.nextcloud = {
                gid = 3005;
                members = [ config.services.mysql.user ];
              };
            };

            system.stateVersion = "24.11";
          };

        bindMounts = {
          ${dataDir} = {
            hostPath = "/mnt/${domain}/data";
            isReadOnly = false;
          };
          "/var/lib/mysql" = {
            hostPath = "/mnt/${domain}/db";
            isReadOnly = false;
          };
          "/var/admin-password" = {
            isReadOnly = true;
          };
          "/var/secrets.json" = {
            isReadOnly = true;
          };
        };
      };

      nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
        port = 80;
        host = address;
        extra-config = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/default/cert.pem";
          sslCertificateKey = "/var/lib/acme/default/key.pem";
          # client_body_buffer_size = "400M";
        };
      };
    };

    fileSystems = {
      "/mnt/${domain}/data" = {
        device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/nextcloud/data";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
      "/mnt/${domain}/db" = {
        device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/nextcloud/db";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
    };

    users = {
      users.${app} = {
        uid = 3003;
        group = app;
        isSystemUser = true;
      };
      groups.${app}.gid = 3005;
    };
  };
}
