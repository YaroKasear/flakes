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
      extraModulePackages = [ ];
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
      kernelModules = [
        "nvidia-uvm"
        "usb-storage"
        "k10temp"
        "nct6775"
      ];
      kernelParams = ["quiet"];
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
      plymouth = {
        enable = true;
        theme = "catppuccin-frappe";
        themePackages = [
          (pkgs.catppuccin-plymouth.override { variant = "frappe"; })
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      # united.hitman-woa
    ];

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
      networkmanager.enable = true;
      wireless.enable = false;
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
      defaultSopsFile = ./secrets.yaml;
      age = {
        keyFile = /etc/syskey;
        sshKeyPaths = [];
      };
      gnupg.sshKeyPaths = [];
      secrets = {
        authfile = {
          path = "/home/yaro/.config/Yubico/u2f_keys";
          mode = "0440";
          owner = config.users.users.yaro.name;
          group = config.users.users.yaro.group;
          sopsFile = ./secrets.yaml;
        };
        hashedpw = {
          neededForUsers = true;
          sopsFile = ./secrets.yaml;
        };
      };
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
      common = {
        enable = true;
      };
      desktop-mounts.enable = true;
      loki-mounts.enable = true;
      steam.enable = true;
    };

    users = {
      mutableUsers = false;
      users.yaro = {
        isNormalUser = true;
        extraGroups = ["wheel" "video" "audio" "networkmanager" "lp" "gamemode"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.sops.secrets.hashedpw.path;
      };
    };
  };
}
