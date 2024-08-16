{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PUBLIC SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    identityPaths = ["/persistent/etc/ssh/ssh_host_ed25519_key"];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBR7FHCr/xnQhQ0eeU14MoH78bF1XQwhA34juRFC9S3A";
    };
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
      wireguard-key =
      {
        rekeyFile = secrets-directory + "wireguard-key";
        path = "/var/wg-key";
        owner = "systemd-network";
        mode = "400";
        symlink = false;
      };
    };
  };

  networking = {
    hostId = "59d99151";
    hostName = "deimos";
    firewall = {
      checkReversePath = "loose";
      logRefusedConnections = true;
      logRefusedPackets = true;
      logReversePathDrops = true;
    };
    wg-quick.interfaces = {
      wg0 = {
        address = ["10.60.10.1/32"];
        dns = ["10.10.0.1" "10.0.0.1"];
        privateKeyFile = config.age.secrets.wireguard-key.path;

        peers = [
          {
            publicKey = "ycvzU34e3KpPadkwkNYFpq2R1n2IkqWbs8ZDBo8NA3c=";
            allowedIPs = ["0.0.0.0/0" "::/0"];
            endpoint = "45.79.35.167:2001";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    nat = {
      enable = true;
      internalInterfaces = [
        "ve-+"
      ];
      # externalInterface = config.systemd.network.networks."20-dmz".matchConfig.Name;
      externalInterface = "wg0";
      externalIP = "10.60.10.1"; # Despite what the documentation says, it does NOT assign the interface's IP...
      extraCommands = ''
        iptables -t nat -A POSTROUTING -d 10.10.0.0/16 -j SNAT --to-source 10.0.10.1
        iptables -t nat -A POSTROUTING -d 10.20.0.0/16 -j SNAT --to-source 10.0.10.1
      '';
    };
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "10-storage" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan40";
        };
        vlanConfig.Id = 40;
      };
    };
    networks = {
      "20-dmz" = {
        matchConfig.Name = "eno2";
        vlan = [
          "vlan40"
        ];
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        routes = [
          {
            routeConfig = {
              Destination = "10.10.0.0/16";
              Gateway = "10.0.0.2";
              GatewayOnLink = true;
            };
          }
          {
            routeConfig = {
              Destination = "10.20.0.0/16";
              Gateway = "10.0.0.2";
              GatewayOnLink = true;
            };
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
      "30-storage" = {
        matchConfig.Name = "vlan40";
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        dhcpV4Config = {
          UseRoutes = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  united = {
    apache-vikali = enabled;
    apache-majike = enabled;
    deimos-mounts = enabled;
    emby = enabled;
    nextcloud = enabled;
    nginx-default = enabled;
    nginx-proxy = enabled;
    nginx-yaro = enabled;
    server = enabled;
    vaultwarden = enabled;
  };

  # START SHORT-TERM CONTAINERS/DOMAINS

  containers = {
    jellyfin = {
      autoStart = false;
      ephemeral = true;
      privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = "192.168.1.18";

      config = { ... }: {
        services = {
          jellyfin = {
            enable = true;
            openFirewall = true;
          };
          dnsmasq = {
            enable = true;
            settings = {
              "server" = [
                "1.1.1.1"
                "1.0.0.1"
              ];
            };
          };
        };

        users = {
          users.jellyfin = {
            uid = config.users.users.yaro.uid;
          };
          groups.jellyfin.gid = config.users.groups.yaro.gid;
        };

        system.stateVersion = "24.05";
      };
      bindMounts = {
        "/mnt/pictures" = {
          hostPath = "/mnt/media.kasear.net/pictures";
          isReadOnly = false;
        };
        "/mnt/music" = {
          hostPath = "/mnt/media.kasear.net/music";
          isReadOnly = false;
        };
        "/mnt/video" = {
          hostPath = "/mnt/media.kasear.net/video";
          isReadOnly = false;
        };
      };
    };
    nginx-proxy.config.services.nginx.virtualHosts."jellyfin.kasear.net" = network.create-proxy {
      port = 8096;
      host = "192.168.1.18";
      extra-config = {
        forceSSL = true;
        sslCertificate = "/var/lib/acme/default/cert.pem";
        sslCertificateKey = "/var/lib/acme/default/key.pem";
      };
    };
  };

  # END CONTAINERS/DOMAINS
}