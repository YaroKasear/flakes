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
    };

    fileSystems."/mnt/containers" = {
      device = "storage.kasear.net:/mnt/data/containers";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
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
      hostName = mkForce "loki";
      hostId = "1d84728f";
      wireless.enable = false;
    };

    united = {
      common = {
        enable = true;
      };
      desktop-mounts.enable = true;
      loki-mounts.enable = true;
      steam.enable = true;
      yaro.enable = true;
    };
  };
}
