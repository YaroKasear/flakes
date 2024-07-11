{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PRIVATE SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ117s7oMUXt8PUsb5hlkbyGCdYgSHXdeaq7GQhFi5z7";
    };
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  containers = {
    home-assistant = {
      autoStart = true;
      privateNetwork = true;
      # x.x.200.x for Private.
      hostAddress = "172.16.200.1";
      localAddress = "172.16.200.2";
      config = ../../../containers/home-assistant/default.nix;
    };
  };

  networking = {
    hostId = "44470514";
    hostName = "phobos";
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = config.systemd.network.networks."30-main".matchConfig.Name;
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
        matchConfig.Name = "enp9s0";
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
        # hashedPasswordFile = config.age.secrets.yaro-password.path;
        initialPassword = "changeme";
      };
    };
  };
}
