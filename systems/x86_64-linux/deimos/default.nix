{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PUBLIC SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
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
  };

  systemd.network = {
    enable = true;
    netdevs = {
    #   "10-wg0" = {
    #     netdevConfig = {
    #       Kind = "wireguard";
    #       Name = "wg0";
    #       MTUBytes = "1500";
    #     };
    #     wireguardConfig = {
    #       PrivateKeyFile = config.age.secrets.wireguard-key.path;
    #     };
    #     wireguardPeers = [
    #      {
    #        wireguardPeerConfig = {
    #          AllowedIPs = [
    #            "0.0.0.0/0"
    #          ];
    #          Endpoint = "45.79.35.167:2001";
    #          PersistentKeepalive = 25;
    #          PublicKey = "ycvzU34e3KpPadkwkNYFpq2R1n2IkqWbs8ZDBo8NA3c=";
    #          };
    #        }
    #     ];
    #   };
      "20-storage" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan40";
        };
        vlanConfig.Id = 40;
      };
    };
    networks = {
      "30-dmz" = {
        matchConfig.Name = "enp9s0";
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      # "40-wg0" = {
      #   matchConfig.Name = "wg0";
      #   address = ["10.60.10.1/32"];
      #   DHCP = "no";
      #   dns = ["10.10.10.1"];
      #   ntp = ["10.10.10.1"];
      #   gateway = ["10.60.0.1"];
      #   networkConfig = {
      #     LinkLocalAddressing = false;
      #     IPv6AcceptRA = false;
      #   };
      #   linkConfig.RequiredForOnline = "yes";
      # };
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
    phobos-mounts = enabled;
    server = enabled;
  };

  users = {
    users = {
      yaro = {
        description = yaro.united.user.fullName;
        home = yaro.united.user.directories.home;
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "systemd-journal"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.age.secrets.yaro-password.path;
        # initialPassword = "changeme";
      };
    };
  };
}
