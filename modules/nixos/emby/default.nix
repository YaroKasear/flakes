{ lib, config, pkgs, ... }:
with lib;
with lib.united;
with pkgs;

let
  cfg = config.united.emby;

  emby-server = callPackage ./emby-server.nix { inherit dataDir; };

  app = "media";
  address = "192.168.1.15";
  dataDir = "/mnt/config";
  domain = "${app}.kasear.net";
in {
  options.united.emby = {
    enable = mkEnableOption "Emby";
  };

  config = mkIf cfg.enable {
    containers.${app} = {
      autoStart = true;
            privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = address;
      config = { ... } : {
        environment.systemPackages = [
          emby-server
        ];

        systemd.services.emby-server = {
          description = "Emby brings together your videos, music, photos, and live television.";
          after = ["network.target"];
          script = ''
            ${emby-server}/bin/emby
          '';
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            User = app;
            Group = app;
            SupplementaryyGroups = ["render" "video"];
            DynamicUser = true;
            StateDirectory = "emby";
            ReadWritePaths = [
              "-/dev/dri"
              dataDir
            ];
            RestartForceExitStatus = 3;
            AmbientCapabilities = "CAP_NET_BIND_SERVICE";
            CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
            LockPersonality = true;
            ProtectControlGroups = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
          };
        };

        networking = {
          firewall = {
            enable = true;
            logReversePathDrops = true;
            allowedTCPPorts = [ 80 ];
          };
          useHostResolvConf = lib.mkForce false;
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

        users = {
          users.${app} = {
            uid = config.users.users.yaro.uid;
            group = app;
            isSystemUser = true;
            home = dataDir;
          };
          groups.${app}.gid = config.users.groups.yaro.gid;
        };

        system.stateVersion = "24.05";
      };
      bindMounts = {
        ${dataDir} = {
          hostPath = "/mnt/${domain}/config";
          isReadOnly = false;
        };
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

    containers.nginx-proxy.config.services.nginx.virtualHosts.${domain} = network.create-proxy {
      port = 80;
      host = address;
      extra-config = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/default/cert.pem";
        sslCertificateKey = "/var/lib/acme/default/key.pem";
      };
    };

    fileSystems = {
      "/mnt/${domain}/config" = {
        device = "storage.kasear.net:/mnt/data/containers/emby/config";
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
