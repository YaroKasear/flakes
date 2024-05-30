{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.loki;
in {
  options.united.loki = {
    enable = mkEnableOption "Common configuration for Loki.";
  };

  config = mkIf cfg.enable {
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
      # kernelPatches = [ {
      #   name = "enable RT_FULL";
      #   patch = null;
      #   extraConfig = ''
      #     PREEMPT y
      #     PREEMPT_BUILD y
      #     PREEMPT_VOLUNTARY n
      #     PREEMPT_COUNT y
      #     PREEMPTION y
      #   '';
      # } ];
    };

    hardware = {
      nvidia = {
        modesetting.enable = true;
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
      networkmanager.enable = false;
      hostName = mkForce "loki";
      hostId = "1d84728f";
      useDHCP = false;
      wireless.enable = false;
    };

    programs.fuse.userAllowOther = true;

    services = {
      dnsmasq = {
        enable = true;
        settings = {
          "server" = ["10.10.10.1"];
        };
      };
      openvpn.servers.work = {
        config = "config ${config.age.secrets.work-vpn.path}";
      };
      resolved.enable = false; # systemd-resolved is cancer
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
      desktop-mounts.enable = true;
      loki-mounts.enable = true;
      steam.enable = true;
    };
  };
}
