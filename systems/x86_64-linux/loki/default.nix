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
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  networking = {
    hostName = "loki";
    networkmanager.enable = true;
  };

  nix = {
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

  systemd = {
    tmpfiles.settings = {
      "10-fix-dotconfig" = {
        "/home/yaro/.config" = {
          d = {
            user = "yaro";
            group = "users";
            mode = "0755";
          };
        };
        "/home/yaro/.config/Yubico" = {
          d = {
            user = "yaro";
            group = "users";
            mode = "0755";
          };
        };
      };
    };
  };

  time.timeZone = "America/Chicago";

  united = {
    desktop-mounts.enable = true;
  };

  security = {
    pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      u2f = {
        cue = true;
        control = "required";
      };
    };
  };

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      keyFile = /etc/syskey;
      sshKeyPaths = [];
    };
    gnupg.sshKeyPaths = [];
    secrets = {
      "security/pam/u2f/authFile" = {
        path = "/home/yaro/.config/Yubico/u2f_keys";
        mode = "0440";
        owner = config.users.users.yaro.name;
        group = config.users.users.yaro.group;
      };
      "users/users/yaro/hashedPasswordFile".neededForUsers = true;
    };
  };

  users = {
    mutableUsers = false;
    users.yaro = {
      isNormalUser = true;
      extraGroups = ["wheel" "video" "audio" "networkmanager" "lp"];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets."users/users/yaro/hashedPasswordFile".path;
    };
  };
}
