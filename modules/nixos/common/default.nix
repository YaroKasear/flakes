{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.common;
in {
  options.united.common = {
    enable = mkEnableOption "Common";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.enable = true;
      kernelModules = [
        "usb-storage"
      ];
      kernelParams = ["quiet"];
      loader = {
        timeout = 0;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
      plymouth.enable = true;
    };

    console = {
      font = "${pkgs.kbd}/share/consolefonts/Lat2-Terminus16.psfu.gz";
      keyMap = "us";
    };

    environment.systemPackages = with pkgs; [
      lm_sensors
      nfs-utils
      nix-diff
      wget
    ];

    hardware.enableRedistributableFirmware = lib.mkDefault true;

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      networkmanager.enable = true;
      useDHCP = lib.mkDefault true;
    };

    nix = {
      optimise.automatic = true;
      package = pkgs.nixFlakes;
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
      ssh.startAgent = false;
      zsh.enable = true;
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
      pam = {
        services = {
          login.u2fAuth = true;
          sudo.u2fAuth = true;
        };
        u2f = {
          cue = true;
          control = lib.mkDefault "sufficient";
        };
      };
    };

    services = {
      dbus.implementation = "broker";
      openssh = {
        enable = true;
      };
      udev.packages = [
        pkgs.yubikey-personalization
      ];
      pcscd.enable = true;
    };

    sops = {
      defaultSopsFile = ./secrets.yaml;
      age = {
        keyFile = /etc/syskey;
        sshKeyPaths = [];
      };
      gnupg.sshKeyPaths = [];
    };

    system.stateVersion = "unstable";

    systemd.enableEmergencyMode = false;

    time.timeZone = "America/Chicago";

    users = {
      mutableUsers = false;
      users.root.hashedPassword = lib.mkDefault "!";
    };
  };
}
