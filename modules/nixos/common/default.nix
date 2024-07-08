{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  common-secrets = inputs.self + "/secrets/common/";

  cfg = config.united.common;
in {
  options.united.common = {
    enable = mkEnableOption "Common";
    splash = mkEnableOption "Boot splash";
  };

  config = mkIf cfg.enable {
    age = {
      rekey = {
        localStorageDir = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/rekey";
        masterIdentities = [ ./files/yubikey.pub ];
        storageMode = "local";
      };
      secrets = {
        yubikey-auth.rekeyFile = common-secrets + "yubikey-auth.age";
      };
    };

    boot = {
      initrd.systemd = enabled;
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
      plymouth = {
        enable = cfg.splash;
        themePackages = with pkgs; [(catppuccin-plymouth.override{ variant = "mocha"; })];
        theme = "catppuccin-mocha";
      };
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
      fuse.userAllowOther = true;
      ssh.startAgent = false;
      zsh = enabled;
    };

    security = {
      polkit = enabled;
      rtkit = enabled;
      sudo = {
        package = pkgs.sudo.override { withInsults = true; };
        extraConfig = ''
          Defaults insults
        '';
      };
      pam = {
        u2f = {
          enable = true;
          authFile = "${config.age.secrets.yubikey-auth.path}";
          cue = true;
          control = "sufficient";
        };
        yubico = {
          enable = true;
          id = "65698";
          control = "sufficient";
        };
        services = {
          login = with config.security.pam.services.login.rules.auth; {
            rules.auth = {
              unix = {
                control = mkForce "required";
                order = u2f.order - 1;
              };
              yubico.order = u2f.order + 1;
            };
            u2fAuth = true;
          };
          sudo = with config.security.pam.services.sudo.rules.auth; {
            rules.auth = {
              unix = {
                control = mkForce "required";
                order = u2f.order - 1;
              };
              yubico.order = u2f.order + 1;
            };
            u2fAuth = true;
          };
        };
      };
    };

    services = {
      dbus.implementation = "broker";
      openssh = enabled;
      udev.packages = [
        pkgs.yubikey-personalization
      ];
    };

    system.stateVersion = "24.05";

    systemd.enableEmergencyMode = false;

    time.timeZone = "America/Chicago";

    users = {
      mutableUsers = false;
      users.root.hashedPassword = lib.mkDefault "!";
    };
  };
}
