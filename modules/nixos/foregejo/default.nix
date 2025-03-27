{ lib, config, inputs, ... }:
with lib;
with lib.united;

let
  cfg = config.united.forgejo;
  secrets-directory = inputs.self + "/secrets/modules/${app}/";

  app = "git";
  address = "192.168.1.20";
  # dataDir = "/var/lib/forgejo";
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

          services.forgejo = {
            enable = true;
            database.type = "postgres";
            # Enable support for Git Large File Storage
            lfs.enable = true;
            settings = {
              server = {
                DOMAIN = domain;
                # You need to specify this to remove the port from URLs in the web UI.
                ROOT_URL = "https://${domain}/";
                HTTP_ADDR = "0.0.0.0";
                HTTP_PORT = 3000;
              };
              # You can temporarily allow registration to create an admin user.
              service.DISABLE_REGISTRATION = true;
            };
          };

          networking.firewall = {
            enable = true;
            allowedTCPPorts = [ 3000 ];
          };

          system.stateVersion = "24.11";
        };
        bindMounts = {
          # ${dataDir} = {
          #   hostPath = "/mnt/${domain}/data";
          #   isReadOnly = false;
          # };
          "/var/pwd".hostPath = config.age.secrets.forgejo-password.path;
        };
      };

      nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
        host = address;
        port = 3000;
        extra-config = {
          forceSSL = true;
          sslCertificate = "/var/lib/acme/default/cert.pem";
          sslCertificateKey = "/var/lib/acme/default/key.pem";
          extraConfig = ''
            auth_pam "Password required!";
            auth_pam_service_name "nginx";

            client_max_body_size 512M;
          '';
        };
      };
    };

    users = {
      users.${app} = {
        group = app;
        isSystemUser = true;
        uid = 999;
      };
      groups.${app}.gid = 999;
    };
  };
}
