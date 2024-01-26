{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      systemd.enable = true;
    };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  console = {
    keyMap = "us";
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "experimental";
    networkmanager.enable = true;
    wireless.enable = false;
    useDHCP = lib.mkDefault true;
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

  nix = {
    package = pkgs.nixFlakes;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  programs = {
    zsh.enable = true;
  };

  time.timeZone = "America/Chicago";

  users = {
    mutableUsers = false;
    users = {
      tester = {
        isNormalUser = true;
        extraGroups = ["wheel" "video" "audio" "networkmanager" "lp"];
        shell = pkgs.zsh;
        home = "/tmp/tester";
        hashedPassword = "$y$j9T$MI4N6awcgzyrBlBaRD64S0$LuLoK77PhSRF5eAIjQRBawTQ.34VC7eAzqV94zTHpT2";
      };
      root.hashedPassword = "!";
    };
  };

  system.stateVersion = "unstable";

  united.base-mounts.enable = true;
}
