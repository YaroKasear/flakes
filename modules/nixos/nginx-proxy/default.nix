{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nginx-proxy;
  secrets-directory = inputs.self + "/secrets/modules/nginx-${app}/";

  app = "proxy";
in
{
  options.united.nginx-proxy = {
    enable = mkEnableOption "nginx-proxy";
  };

  config = mkIf cfg.enable {
    age.secrets."cf-credentials.env" = {
      rekeyFile = secrets-directory + "cf-credentials.env.age";
      path = "/var/cf-credentials.env";
      owner = "nginx";
      mode = "400";
      symlink = false;
    };

    containers = {
      "nginx-${app}" = {
        autoStart = true;

        config = { pkgs, ... }:
          {
            security = {
              pam.services.nginx.setEnvironment = false;
              acme = {
                acceptTerms = true;
                certs = {
                  default = {
                    domain = "*.kasear.net";
                    extraDomainNames = [ "kasear.net" ];
                  };
                };
                defaults = {
                  email = "yaro@kasear.net";
                  group = "${app}";
                  dnsProvider = "cloudflare";
                  dnsResolver = "1.1.1.1";
                  environmentFile = config.age.secrets."cf-credentials.env".path;
                };
              };
            };

            programs.zsh.enable = true;

            services = {
              nginx = {
                enable = true;
                package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
                additionalModules = [ pkgs.nginxModules.pam ];
                recommendedOptimisation = true;
                recommendedProxySettings = true;
                recommendedTlsSettings = true;
                clientMaxBodySize = "10G";
              };
            };

            users = {
              users = {
                acme.uid = 3001;
                yaro = config.users.users.yaro;
              };
              groups = {
                yaro = config.users.groups.yaro;
                proxy = {
                  gid = 3003;
                  members = [ "nginx" "acme" ];
                };
              };
            };

            networking.firewall = {
	      logRefusedConnections = true;
	      logRefusedPackets = true;
	      logReversePathDrops = true;
	    };

            system.stateVersion = "24.11";

            systemd.services.nginx.serviceConfig = {
              SupplementaryGroups = [ "shadow" ];
            };
          };

        bindMounts = {
          "/var/lib/acme" = {
            hostPath = "/mnt/proxy/data";
            isReadOnly = false;
          };
          "/var/cf-credentials.env" = {
            hostPath = config.age.secrets."cf-credentials.env".path;
            isReadOnly = true;
          };
	  "${config.age.secrets.yaro-password.path}".hostPath = config.age.secrets.yaro-password.path;
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
    };

    fileSystems."/mnt/proxy/data" = {
      device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/acme";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    users = {
      users = {
        nginx = {
          uid = config.ids.uids.nginx;
          group = "nginx";
        };
      };
      groups = {
        nginx.gid = config.ids.gids.nginx;
      };
    };
  };
}
