{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
    };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  united.common.enable = true;

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.enable = false;
  };

  time.timeZone = "America/Chicago";

  united = {
    kmscon.enable = true;
  };

  users = {
    mutableUsers = false;
    users.yaro = {
      isNormalUser = true;
      extraGroups = ["wheel" "video" "audio" "networkmanager" "lp"];
      shell = pkgs.zsh;
      hashedPassword = "$y$j9T$T0.EZsbf6QuoxAMMsJIi60$IwpsT47bau7p5um0X6oIZEzFofXdECv1PYSXGaGiDhD";
    };
  };
}
