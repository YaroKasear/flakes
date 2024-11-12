{ lib, config, pkgs, inputs, ... }:
with lib;
with lib.united;
with pkgs;

let
  cfg = config.united.jellyfin;

  xmltvScript = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/daniel-widrick/zap2it-GuideScraping/main/zap2it-GuideScrape.py";
    hash = "sha256-xO1rujHBMjqKKfR7JvYwnon/L2+rZSe3mcemom3R42s=";
  };

  app = "media";
  address = "192.168.1.15";
  dataDir = "/var/lib/jellyfin";
  domain = "${app}.kasear.net";
  secrets-directory = inputs.self + "/secrets/modules/nginx-${app}/";
in
{
  options.united.jellyfin = {
    enable = mkEnableOption "jellyfin";
  };

  config = mkIf cfg.enable {
    age.secrets."xmltv.ini" = {
      rekeyFile = secrets-directory + "xmltv.ini.age";
      path = "/var/xmltv.ini";
      owner = "jellyfin";
      mode = "400";
      symlink = false;
    };

    containers.${app} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = address;
      forwardPorts = [
        {
          containerPort = 1900;
          hostPort = 1900;
          protocol = "udp";
        }
        {
          containerPort = 7359;
          hostPort = 7359;
          protocol = "udp";
        }
      ];
      config = { ... }: {
        networking.useHostResolvConf = lib.mkForce false;

        environment.systemPackages = [ python3 ];

        services = {
          jellyfin = {
            enable = true;
            openFirewall = true;
          };
          dnsmasq = {
            enable = mkDefault true;
            settings = {
              "server" = [
                "1.1.1.1"
                "1.0.0.1"
              ];
            };
          };
        };

        systemd = {
          services.xmltv = {
            script = ''
              ${python3}/bin/python ${xmltvScript} -c /var/xmltv.ini -o ${dataDir}/xmltv.xml
            '';
            serviceConfig = {
              Type = "oneshot";
              User = "jellyfin";
            };
          };
          timers.xmltv = {
            wantedBy = [ "time.target" ];
            timerConfig = {
              OnCalendar = "daily";
              Persistent = true;
            };
          };
        };

        users = {
          users.jellyfin = {
            uid = 3004;
            extraGroups = [ "media" ];
          };
          groups = {
            jellyfin.gid = 3006;
            media.gid = 1001;
          };
        };

        system.stateVersion = "unstable";
      };
      bindMounts = {
        ${dataDir} = {
          hostPath = "/mnt/${domain}/config";
          isReadOnly = false;
        };
        "/var/xmltv.ini".isReadOnly = true;
        "/mnt/pictures" = {
          hostPath = "/mnt/${domain}/pictures";
          isReadOnly = false;
        };
        "/mnt/music" = {
          hostPath = "/mnt/${domain}/music";
          isReadOnly = false;
        };
        "/mnt/video" = {
          hostPath = "/mnt/${domain}/video";
          isReadOnly = false;
        };
      };
    };

    networking.firewall.allowedUDPPorts = [
      1900
      7359
    ];

    containers.nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
      port = 8096;
      host = address;
      extra-config = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/default/cert.pem";
        sslCertificateKey = "/var/lib/acme/default/key.pem";
      };
    };

    users = {
      users.jellyfin = {
        isSystemUser = true;
        uid = 3004;
        group = "jellyfin";
      };
      groups.jellyfin.gid = 3006;
    };

    fileSystems = {
      "/mnt/${domain}/config" = {
        device = "storage.kasear.net:/mnt/data/server/deimos/jellyfin/config";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
      "/mnt/${domain}/pictures" = {
        device = "storage.kasear.net:/mnt/data/storage/pictures";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
      "/mnt/${domain}/music" = {
        device = "storage.kasear.net:/mnt/data/storage/music";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
      "/mnt/${domain}/video" = {
        device = "storage.kasear.net:/mnt/data/storage/video";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "_netdev" ];
      };
    };
  };
}
