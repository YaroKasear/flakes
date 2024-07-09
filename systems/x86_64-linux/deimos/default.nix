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

  networking = {
    hostId = "44470514";
    hostName = "deimos";
  };

  systemd.network = {
    enable = true;

    netdevs."10-iot" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan30";
      };
      vlanConfig.Id = 30;
    };

    networks = {
      "20-main" = {
        matchConfig.Name = "enp9s0";
        vlan = ["vlan30"];
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = false;
          IPv6AcceptRA = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "30-iot" = {
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
    };
  };

  united = {
    deimos-mounts = enabled;
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
      };
    };
  };
}
