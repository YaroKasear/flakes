{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.loki;
in {
  options.united.loki = {
    enable = mkEnableOption "Common configuration for Loki.";
  };

  config = mkIf cfg.enable {
    age.identityPaths = ["/persistent/etc/ssh/ssh_host_ed25519_key"];
    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "sd_mod"
        ];
      };
      kernelModules = [
        "nvidia-uvm"
        "k10temp"
        "nct6775"
      ];
    };

    hardware = {
      nvidia = {
        modesetting = enabled;
        powerManagement = {
          enable = false;
          finegrained = false;
        };
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    networking = {
      networkmanager = disabled;
      hostName = mkForce "loki";
      hostId = "1d84728f";
      useDHCP = false;
      wireless = disabled;
    };

    programs.fuse.userAllowOther = true;

    security = {
      pam = {
        services = {
          login.u2fAuth = true;
          sudo.u2fAuth = true;
        };
        u2f = {
          authFile = "${config.age.secrets.yubikey-auth.path}";
          cue = true;
          control = lib.mkDefault "required";
        };
      };
    };

    services = {
      dnsmasq = {
        enable = true;
        settings = {
          "server" = ["10.10.10.1"];
        };
      };
      gpm = enabled;
      openvpn.servers.work = {
        config = "config ${config.age.secrets.work-vpn.path}";
      };
      pcscd = enabled;
      resolved = disabled; # systemd-resolved is cancer
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
        "30-storage" = {
          matchConfig.Name = "enp4s0f4";
          networkConfig = {
            DHCP = "ipv4";
            LinkLocalAddressing = false;
            IPv6AcceptRA = false;
          };
          dhcpV4Config = {
            UseRoutes = false;
          };
          linkConfig = {
            MTUBytes = "9000";
            RequiredForOnline = "routable";
          };
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
      };
    };

    united = {
      common = {
        enable = true;
      };
      desktop-mounts = enabled;
      loki-mounts = enabled;
      steam = enabled;
    };
  };
}
