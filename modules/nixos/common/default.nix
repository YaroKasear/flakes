{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.common;
in {
  options.united.common = {
    enable = mkEnableOption "Common";
    splash = mkEnableOption "Boot splash";
  };

  config = mkIf cfg.enable {
    boot = {
      initrd.systemd.enable = true;
      kernelModules = [
        "usb-storage"
      ];
      kernelParams = [
        (mkIf cfg.splash "quiet")
      ];
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
      plymouth.enable = cfg.splash;
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

    home-manager.backupFileExtension = "bak";

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      networkmanager.enable = mkDefault true;
      useDHCP = lib.mkDefault true;
    };

    nix = {
      optimise.automatic = true;
      package = pkgs.nixFlakes;
      gc = {
        automatic = true;
        dates = "weekly";
      };
      extraOptions = ''
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (5 * 1024 * 1024 * 1024)}
      '';
      settings.auto-optimise-store = true;
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
          authFile = "/run/secrets/authfile";
          cue = true;
          control = lib.mkDefault "required";
        };
      };
      sudo = {
        package = pkgs.sudo.override { withInsults = true; };
        extraConfig = ''
          Defaults insults
        '';
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
