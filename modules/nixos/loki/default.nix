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
      initrd = {
        availableKernelModules = [
          "ahci"
          "nfs"
          "nfs4"
          "nvme"
          "sd_mod"
          "usbhid"
          "xhci_pci"
        ];
        supportedFilesystems = ["nfs" "nfs4"];
      };
      kernelModules = [
        "nvidia-uvm"
        "k10temp"
        "nct6775"
      ];
      kernelParams = [
        "nvidia-drm.fbdev=1"
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
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
    };

    networking = {
      hostName = "loki";
      hostId = "1d84728f";
    };

    services = {
      gpm = enabled;
      pcscd = {
        enable = true;
        plugins = [ pkgs.stable.ccid ];
      };
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
