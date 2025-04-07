{ lib, config, inputs, ... }:
with lib;
with lib.united;

let
  cfg = config.united.forgejo;
  secrets-directory = inputs.self + "/secrets/modules/${app}/";

  app = "git";
  address = "192.168.1.20";
  dataDir = "/var/lib/forgejo";
  domain = "${app}.kasear.net";
in
{
  options.united.forgejo = {
    enable = mkEnableOption "ForgeJo";
  };

  config = mkIf cfg.enable {
    age.secrets."forgejo-password" = {
      rekeyFile = secrets-directory + "forgejo-password.age";
      path = "/var/forgejo-password";
      owner = app;
      mode = "400";
      symlink = false;
    };

    containers = {
      ${app} = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.1";
        localAddress = address;
        config = { lib, pkgs, ... }: {
          systemd.services.forgejo.preStart =
            let
              adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
              pwd = "/var/pwd";
              user = "yaro"; # Note, Forgejo doesn't allow creation of an account named "admin"
            in
            ''
              ${adminCmd} create --admin --email "yaro@kasear.net" --username ${user} --password "$(tr -d '\n' < ${pwd})" || true
              ## uncomment this line to change an admin user which was already created
              # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd})" || true
            '';

          services = {
            forgejo = {
              enable = true;
              database.user = app;
              lfs.enable = true;
              stateDir = dataDir;
              user = app;
              group = app;
              settings = {
                server = {
                  DOMAIN = domain;
                  ROOT_URL = "https://${domain}/";
                  HTTP_ADDR = "0.0.0.0";
                  HTTP_PORT = 3000;
                };
                migration = {
                  ALLOWED_DOMAINS = "*.github.com,github.com,gitlab.com";
                  ALLOW_LOCALNETWORKS = true;
                };
                service.DISABLE_REGISTRATION = true;
              };
            };
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

          networking.firewall = {
            enable = true;
            allowedTCPPorts = [ 3000 ];
          };

          programs = {
            tcpdump.enable = true;
            zsh.enable = true;
          };

          users = {
            users.${app} = config.users.users.${app};
            groups.${app} = config.users.groups.${app};
          };

          system.stateVersion = "24.11";
        };
        bindMounts = {
          ${dataDir} = {
            hostPath = "/mnt/${domain}/data";
            isReadOnly = false;
          };
          "/var/pwd".hostPath = config.age.secrets.forgejo-password.path;
          "/run/agenix/yaro-password".hostPath = config.age.secrets.yaro-password.path;
        };
      };

      nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
        host = address;
        port = 3000;
        extra-config = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/default/cert.pem";
          sslCertificateKey = "/var/lib/acme/default/key.pem";
        };
      };
    };

    fileSystems."/mnt/${domain}" = {
      device = "storage.kasear.net:/mnt/data/server/${config.networking.hostName}/forgejo";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    users = {
      users.${app} = {
        group = app;
        isSystemUser = true;
        uid = 3006;
      };
      groups.${app}.gid = 3008;
    };
  };
}
