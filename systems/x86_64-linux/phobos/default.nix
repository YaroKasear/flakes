{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PRIVATE SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDufZoSg+Rv4WD2EJ7RCPRN8v4Db7ypwpd7yKH7a9Tax";
    };
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
      mosquitto-yaro-password.rekeyFile = secrets-directory + "mosquitto-yaro-password.age";
    };
  };

  containers = {
    hass = {
      autoStart = true;
      config = ../../../containers/home-assistant/default.nix;
      ephemeral = true;
    };
    mosquitto = {
      autoStart = true;
      config = ../../../containers/mosquitto/default.nix;
      ephemeral = true;
      bindMounts = {
        "/var/yaro-password" = {
          hostPath = config.age.secrets.mosquitto-yaro-password.path;
          isReadOnly = true;
        };
      };
    };
    nodered = {
      autoStart = true;
      config = ../../../containers/nodered/default.nix;
      ephemeral = true;
    };
  };

  networking = {
    hostId = "44470514";
    hostName = "phobos";
    firewall = {
      allowedTCPPorts = [
        1883
        8123
        1880
        3456
      ];
      allowedUDPPorts = [ 53 ];
    };
  };

  systemd.network = {
    enable = true;

    netdevs = {
      # "10-iot" = {
      #   netdevConfig = {
      #     Kind = "vlan";
      #     Name = "vlan30";
      #   };
      #   vlanConfig.Id = 30;
      # };
      # "20-storage" = {
      #   netdevConfig = {
      #     Kind = "vlan";
      #     Name = "vlan40";
      #   };
      #   vlanConfig.Id = 40;
      # };
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
      # "40-iot" = {
      #   matchConfig.Name = "vlan30";
      #   networkConfig = {
      #     DHCP = "ipv4";
      #     LinkLocalAddressing = false;
      #     IPv6AcceptRA = false;
      #   };
      #   dhcpV4Config = {
      #     UseRoutes = false;
      #   };
      #   linkConfig.RequiredForOnline = "routable";
      # };
      # "50-storage" = {
      #   matchConfig.Name = "vlan40";
      #   networkConfig = {
      #     DHCP = "ipv4";
      #     LinkLocalAddressing = false;
      #     IPv6AcceptRA = false;
      #   };
      #   dhcpV4Config = {
      #     UseRoutes = false;
      #   };
      #   linkConfig.RequiredForOnline = "routable";
      # };
    };
  };

  united = {
    phobos-mounts = enabled;
    server = enabled;
    # https://github.com/YaroKasear/flakes/issues/3
    protomuck = {
      enable = true;
      game-name = "Sandbox";
      main-port = 2560;
    };
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
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMDVGJiUIaIi66ZnsR/M89BfVoMZuhrP19fqYJNryMMf19Q6b32cVSOwTDOgPcHBT88GjJ5whhAoVMOvUNB1q4GJH/T1bfF5CsiMSgad8HubM+RV9tHuRWvenJPeZrm0WtGjZxTjTfZXMehqBb64bbSBJtSe9I4XvfwrUt2/0c5qUSSMgD1RbTOkTasy8HPkr+bFiq3iByOzcJWhPUvD/yBz6mTs3GBy/4Qq/9j4Cswn0rx8esUDQjRlQv6zY4SmjHs+OsGOJZSap7Cwg2WyN9yfpXg3GfsmQyPybx/u4KAo2Wv/nFwaNelfAIISc3fkUPu7wvSS+Wmi7D3N9npa0wlQRDbUwlWp7zbrUorCJRrXxGJkqrI8jy8N0cBEJ3o8xDojBCdVsMn3rz5mgFixl0hqXZ2y0Mwi0D7wk1nYQXsoJOCs/PoGJ0esI6qu/rOVhZ9t44agLTOFKZXbAbRPG7DjNObWV+mJEq8GPt/tcXSSIj4O/r61rzZ53pwFKkslmBlggHWvcA3uzV2BHRyGK20UxSnlwow9iyLthuPAxDwHrq0O8yImOuU8xkbaraUWkulTcnltkYxtzTFDXdksUaNmigca9pwtqCJe7vhoAkVUhljqZzhDvqzwCWHwJjtTPwOK1GPhzptO2qAabXVuMK+Eeuhzvfv2GkW45CSh/G6Q== cardno:16_751_940"
        ];
      };
    };
  };
}
