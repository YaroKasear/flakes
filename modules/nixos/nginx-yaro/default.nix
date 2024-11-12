{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nginx-yaro;

  app = "yaro";
  address = "192.168.1.11";
  dataDir = "/srv/www/root";
  domain = "${app}.kasear.net";
  cf = config.containers."nginx-${app}".config;
in
{
  options.united.nginx-yaro = {
    enable = mkEnableOption "nginx-yaro";
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
              phpfpm.pools.${app} = {
                user = cf.services.nginx.user;
                settings = {
                  "listen.owner" = cf.services.nginx.user;
                  "pm" = "dynamic";
                  "pm.max_children" = 32;
                  "pm.max_requests" = 500;
                  "pm.start_servers" = 2;
                  "pm.min_spare_servers" = 2;
                  "pm.max_spare_servers" = 5;
                  "php_admin_value[error_log]" = "stderr";
                  "php_admin_flag[log_errors]" = true;
                  "catch_workers_output" = true;
                };
                phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
              };

              nginx = {
                enable = true;
                user = "${app}";
                group = "${app}";
                recommendedOptimisation = true;
                virtualHosts."${domain}".locations = {
                  "/" = {
                    root = dataDir;
                  };
                  "~ \.php$" = {
                    root = dataDir;
                    extraConfig = ''
                      fastcgi_split_path_info ^(.+\.php)(/.+)$;
                      fastcgi_pass unix:${cf.services.phpfpm.pools.${app}.socket};
                      include ${pkgs.nginx}/conf/fastcgi_params;
                      include ${pkgs.nginx}/conf/fastcgi.conf;
                    '';
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

            users = {
              users.${app} = {
                uid = 1000;
                group = app;
                isSystemUser = true;
                home = dataDir;
              };
              groups.${app}.gid = 3001;
            };

            system.stateVersion = "unstable";
          };

        bindMounts."${dataDir}" = {
          hostPath = "/mnt/${domain}/data";
          isReadOnly = true;
        };
      };

      nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
        host = address;
        port = 80;
        extra-config = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/default/cert.pem";
          sslCertificateKey = "/var/lib/acme/default/key.pem";
        };
      };
    };

    fileSystems."/mnt/${domain}/data" = {
      device = "storage.kasear.net:/mnt/data/user/yaro/public_html";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };
  };
}
