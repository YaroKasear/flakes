{ lib, pkgs, inputs, config, ... }:
with lib.united;

# PRIVATE SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in
{
  age = {
    identityPaths = [ "/persistent/etc/ssh/ssh_host_ed25519_key" ];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxsAeBUl/O+YJ7mGfwH3BskpBV1eSDKJ0QQPlnIEoDK";
    };
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
      mosquitto-yaro-password.rekeyFile = secrets-directory + "mosquitto-yaro-password.age";
    };
  };

  containers = {
    mosquitto = {
      autoStart = true;
      config = ../../../containers/mosquitto/default.nix;
      bindMounts = {
        "/var/yaro-password" = {
          hostPath = config.age.secrets.mosquitto-yaro-password.path;
          isReadOnly = true;
        };
      };
    };
  };

  networking = {
    hostId = "44470514";
    hostName = "phobos";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        1880
      ];
      allowedUDPPorts = [ 53 ];
      logRefusedConnections = true;
      logRefusedPackets = true;
      logReversePathDrops = true;
    };
  };

  systemd.network = {
    enable = true;

    netdevs = {
      "10-iot" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan30";
        };
        vlanConfig.Id = 30;
      };
      "20-storage" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan40";
        };
        vlanConfig.Id = 40;
      };
    };

    networks = {
      "30-main" = {
        # WARNING: Make sure this matches the actual iface name. iptables doesn't understand what an "altname" is.
        matchConfig.Name = "eno2";
        vlan = [
          "vlan30"
          "vlan40"
        ];
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "40-iot" = {
        matchConfig.Name = "vlan30";
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
      "50-storage" = {
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
    asterisk = enabled;
    audiobookshelf = enabled;
    home-assistant = enabled;
    nodered = enabled;
    phobos-mounts = enabled;
    # https://github.com/YaroKasear/flakes/issues/3
    protomuck = {
      enable = true;
      game-name = "Sandbox";
      main-port = 2560;
    };
    server = enabled;
    tailscale = {
      enable = true;
      exitNode = true;
    };
    common.banner = ''
      [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░[0m
      [90;40m░[91m█▀█[90m░[91m█[90m░[91m█[90m░[91m█▀█[90m░[91m█▀▄[90m░[91m█▀█[90m░[91m█▀▀[90m░[0m
      [90;40m░[91m█▀▀[90m░[91m█▀█[90m░[91m█[90m░[91m█[90m░[91m█▀▄[90m░[91m█[90m░[91m█[90m░[91m▀▀█[90m░[0m
      [90;40m░[91m▀[90m░░░[91m▀[90m░[91m▀[90m░[91m▀▀▀[90m░[91m▀▀[90m░░[91m▀▀▀[90m░[91m▀▀▀[90m░[0m
      [90;40m░░░░░░░░░░░░░░░░░░░░░░░░░[0m
    '';
  };
}
