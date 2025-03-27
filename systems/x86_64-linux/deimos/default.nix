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
      # internalInterfaces = [
      #   "ve-+"
      # ];
      # externalInterface = config.systemd.network.networks."20-dmz".matchConfig.Name;
      # externalInterface = "wg0";
      # externalIP = "10.60.10.1"; # Despite what the documentation says, it does NOT assign the interface's IP...
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
            Destination = "10.10.0.0/16";
            Gateway = "10.0.0.2";
            GatewayOnLink = true;
          }
          {
            Destination = "10.20.0.0/16";
            Gateway = "10.0.0.2";
            GatewayOnLink = true;
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
    apache-majike = disabled;
    deimos-mounts = enabled;
<<<<<<< Updated upstream
    jellyfin = disabled;
    nextcloud = disabled;
    nginx-default = disabled;
    nginx-proxy = disabled;
    nginx-yaro = disabled;
=======
    headscale = enabled;
    jellyfin = enabled;
    minecraft = enabled;
    forgejo = enabled;
    nextcloud = enabled;
    nginx-default = enabled;
    nginx-proxy = enabled;
    nginx-yaro = enabled;
>>>>>>> Stashed changes
    server = enabled;
    vaultwarden = disabled;
    common.banner = ''
      [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░[0m
      [90;40m░[94m█▀▄[90m░[94m█▀▀[90m░[94m▀█▀[90m░[94m█▄█[90m░[94m█▀█[90m░[94m█▀▀[90m░[0m
      [90;40m░[94m█[90m░[94m█[90m░[94m█▀▀[90m░░[94m█[90m░░[94m█[90m░[94m█[90m░[94m█[90m░[94m█[90m░[94m▀▀█[90m░[0m
      [90;40m░[94m▀▀[90m░░[94m▀▀▀[90m░[94m▀▀▀[90m░[94m▀[90m░[94m▀[90m░[94m▀▀▀[90m░[94m▀▀▀[90m░[0m
      [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░[0m
    '';
    web-applications = {
      hostInterface = "wg0";
      hostIP = "10.60.10.1";
      defaultDomain = "kasear.net";
      extraDomains = [
        "bethybee.com"
      ];
      tlsConfig = {
        method = "dns";
        provider = "cloudflare";
      };
    };
  };

  # START SHORT-TERM CONTAINERS/DOMAINS

  # END CONTAINERS/DOMAINS
}