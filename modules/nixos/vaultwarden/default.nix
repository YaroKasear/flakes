{ lib, config, inputs, ... }:
with lib;
with lib.united;

let
  cfg = config.united.vaultwarden;
  secrets-directory = inputs.self + "/secrets/modules/${app}/";

  app = "vault";
  address = "192.168.1.16";
  dataDir = "/var/lib/bitwarden_rs/";
  domain = "${app}.kasear.net";
in {
  options.united.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
  };

  config = mkIf cfg.enable {
    age = {
      secrets = {
        "vaultwarden.env" =
        {
          rekeyFile = secrets-directory + "vaultwarden.env.age";
          path = "/var/vaultwarden.env";
          owner = "vaultwarden";
          mode = "400";
          symlink = false;
        };
      };
    };

    containers.${app} = {
      autoStart = true;
            privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = address;
      config = { ... }: {
        services.vaultwarden = {
          enable = true;
          config = {
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = 8000;
          };
          environmentFile = "/var/vaultwarden.env";
        };

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ 8000 ];
          };
          useHostResolvConf = lib.mkForce false;
        };

        users = {
          users.vaultwarden = {
            uid = 3002;
            group = "vaultwarden";
          };
          groups.vaultwarden.gid = 3004;
        };

        services.dnsmasq = {
          enable = mkDefault true;
          settings = {
            "server" = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          };
        };

        system.stateVersion = "24.05";
      };
      bindMounts.${dataDir} = {
        hostPath = "/mnt/${domain}";
        isReadOnly = false;
      };
      bindMounts."/var/vaultwarden.env" = {
        hostPath = config.age.secrets."vaultwarden.env".path;
        isReadOnly = true;
      };
    };

    containers.nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
      port = 8000;
      host = address;
      extra-config = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/default/cert.pem";
        sslCertificateKey = "/var/lib/acme/default/key.pem";
      };
    };

    fileSystems."/mnt/${domain}" = {
      device = "storage.kasear.net:/mnt/data/containers/vault";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "_netdev" ];
    };

    users = {
      users.vaultwarden = {
        isSystemUser = true;
        uid = 3002;
        group = "vaultwarden";
      };
      groups.vaultwarden.gid = 3004;
    };
  };
}