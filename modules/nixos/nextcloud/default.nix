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
in {
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
        ephemeral = true;
        privateNetwork = true;
        hostAddress = "192.168.1.1";
        localAddress = address;

        config = { pkgs, ... }:
        {
          services = {
            nextcloud = {
              enable = true;
              hostName = domain;
              https = true;
              database.createLocally = true;
              settings = {
                default_phone_region = "US";
                log_type = "file";
                maintenance_window_start = 1;
                trusted_proxies = ["192.168.1.1"];
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
            dnsmasq = {
              enable = mkDefault true;
              settings = {
                "server" = [
                  "10.10.0.1"
                  "10.0.0.1"
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

          system.stateVersion = "24.05";
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