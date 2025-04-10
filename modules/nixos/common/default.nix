{ lib, config, pkgs, inputs, ... }:
with lib;
with lib.united;

let
  common-secrets = inputs.self + "/secrets/common/";

  cfg = config.united.common;

  breakupString = s: strings.splitString "" s;

  spaceString = s: strings.concatMapStrings (x: " " + x) (breakupString s);
in
{
  options.united.common = {
    enable = mkEnableOption "Common";
    splash = mkEnableOption "Boot splash";
    banner = mkOpt types.lines ''[32m<<[31m${strings.toUpper (spaceString config.networking.hostName)} [32m>>[0m'' "Banner for TTY login screen.";
    mountFlake = mkEnableOption "Should I mount the flake from the storage server?";
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
          enable = mkDefault true;
          configurationLimit = 5;
          memtest86.enable = (pkgs.system == "x86_64-linux");
          netbootxyz = enabled;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
      plymouth = {
        enable = cfg.splash;
        themePackages = with pkgs; [
          (catppuccin-plymouth.override { variant = "mocha"; })
          config.nur.repos.abszero.plymouth-themes
        ];
        theme = "green_blocks";
      };
    };

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-i20n.psf.gz";
      keyMap = "us";
      colors = with config.home-manager.users.yaro.united.style.colors; [
        "${strings.removePrefix "#" color0}"
        "${strings.removePrefix "#" color1}"
        "${strings.removePrefix "#" color2}"
        "${strings.removePrefix "#" color3}"
        "${strings.removePrefix "#" color4}"
        "${strings.removePrefix "#" color5}"
        "${strings.removePrefix "#" color6}"
        "${strings.removePrefix "#" color7}"
        "${strings.removePrefix "#" color8}"
        "${strings.removePrefix "#" color9}"
        "${strings.removePrefix "#" color10}"
        "${strings.removePrefix "#" color11}"
        "${strings.removePrefix "#" color12}"
        "${strings.removePrefix "#" color13}"
        "${strings.removePrefix "#" color14}"
        "${strings.removePrefix "#" color15}"
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        lm_sensors
        nfs-utils
        nix-diff
        wget
      ];
      etc.issue.text = ''

        ${cfg.banner}

        [32;40m${config.system.nixos.distroName} ${config.system.nixos.label}[0m
        [95;40m\s \r (\l \b)[0m
        [95;40m\t \d[0m

      '';
    };

    fileSystems."${config.home-manager.users.yaro.united.user.directories.home}/flakes" = mkIf cfg.mountFlake {
      device = "storage.kasear.net:/mnt/data/flake";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };

    hardware.enableRedistributableFirmware = lib.mkDefault true;

    home-manager.backupFileExtension = "hm-backup";

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      networkmanager = disabled;
      useDHCP = false;
      wireless = mkDefault disabled;
    };

    nix = {
      package = inputs.lix-module.packages.${pkgs.system}.default;
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "weekly";
      };
      extraOptions = ''
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (5 * 1024 * 1024 * 1024)}
      '';
      settings = {
        auto-optimise-store = true;
        trusted-users = config.users.groups.wheel.members;
      };
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
    };

    services = {
      dbus.implementation = "broker";
      dnsmasq = {
        enable = mkDefault true;
        settings = {
          "server" =
            if config.united.tailscale.enable && config.united.tailscale.accept-dns then
              [ "100.100.100.100" ]
            else
              [
                "10.10.10.1"
                "10.0.10.1"
              ];
        };
      };
      fwupd = enabled;
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };
      resolved = disabled; # systemd-resolved is cancer
      udev.packages = [
        pkgs.yubikey-personalization
      ];
    };

    system.stateVersion = "24.11";

    systemd.enableEmergencyMode = false;

    time.timeZone = "America/Chicago";

    united.pam.enable = mkDefault true;

    users = {
      mutableUsers = false;
      users = {
        root.hashedPassword = lib.mkDefault "!";
        yaro = {
          uid = 1000;
          description = config.home-manager.users.yaro.united.user.fullName;
          home = config.home-manager.users.yaro.united.user.directories.home;
          isNormalUser = true;
          extraGroups = [ "wheel" "systemd-journal" "yaro" ];
          shell = pkgs.zsh;
          hashedPasswordFile = mkDefault config.age.secrets.yaro-password.path;
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMDVGJiUIaIi66ZnsR/M89BfVoMZuhrP19fqYJNryMMf19Q6b32cVSOwTDOgPcHBT88GjJ5whhAoVMOvUNB1q4GJH/T1bfF5CsiMSgad8HubM+RV9tHuRWvenJPeZrm0WtGjZxTjTfZXMehqBb64bbSBJtSe9I4XvfwrUt2/0c5qUSSMgD1RbTOkTasy8HPkr+bFiq3iByOzcJWhPUvD/yBz6mTs3GBy/4Qq/9j4Cswn0rx8esUDQjRlQv6zY4SmjHs+OsGOJZSap7Cwg2WyN9yfpXg3GfsmQyPybx/u4KAo2Wv/nFwaNelfAIISc3fkUPu7wvSS+Wmi7D3N9npa0wlQRDbUwlWp7zbrUorCJRrXxGJkqrI8jy8N0cBEJ3o8xDojBCdVsMn3rz5mgFixl0hqXZ2y0Mwi0D7wk1nYQXsoJOCs/PoGJ0esI6qu/rOVhZ9t44agLTOFKZXbAbRPG7DjNObWV+mJEq8GPt/tcXSSIj4O/r61rzZ53pwFKkslmBlggHWvcA3uzV2BHRyGK20UxSnlwow9iyLthuPAxDwHrq0O8yImOuU8xkbaraUWkulTcnltkYxtzTFDXdksUaNmigca9pwtqCJe7vhoAkVUhljqZzhDvqzwCWHwJjtTPwOK1GPhzptO2qAabXVuMK+Eeuhzvfv2GkW45CSh/G6Q== cardno:16_751_940"
          ];
        };
      };
      groups.yaro.gid = 3001;
    };
  };
}
