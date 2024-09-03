{ lib, pkgs, config, ... }:
with lib.united;
with config.home-manager.users;

{
  age.rekey.masterIdentities = [ ./files/yubikey.pub ];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelModules = [
      "usb-storage"
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
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "mode=755" ];
  };

  networking = {
    hostName = "minimal";
    networkmanager = enabled;
  };

  nix = {
    optimise.automatic = true;
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

  nixpkgs.hostPlatform = "x86_64-linux";

  programs.zsh = enabled;

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        "server" = [
          "10.10.0.1"
          "10.0.0.1"
        ];
      };
    };
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    resolved = disabled; # systemd-resolved is cancer
  };

  system.stateVersion = "24.05";

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = lib.mkDefault "!";
      yaro = {
        isNormalUser = true;
        extraGroups = ["wheel" "systemd-journal" "yaro"];
        shell = pkgs.zsh;
        hashedPassword = "$y$j9T$BNRXCN1UfmrkGC6oMuk8x.$DNyJfYjPRSvZ/DANqE.f9onKW3rXt6kdPIk7XSjIPK3";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMDVGJiUIaIi66ZnsR/M89BfVoMZuhrP19fqYJNryMMf19Q6b32cVSOwTDOgPcHBT88GjJ5whhAoVMOvUNB1q4GJH/T1bfF5CsiMSgad8HubM+RV9tHuRWvenJPeZrm0WtGjZxTjTfZXMehqBb64bbSBJtSe9I4XvfwrUt2/0c5qUSSMgD1RbTOkTasy8HPkr+bFiq3iByOzcJWhPUvD/yBz6mTs3GBy/4Qq/9j4Cswn0rx8esUDQjRlQv6zY4SmjHs+OsGOJZSap7Cwg2WyN9yfpXg3GfsmQyPybx/u4KAo2Wv/nFwaNelfAIISc3fkUPu7wvSS+Wmi7D3N9npa0wlQRDbUwlWp7zbrUorCJRrXxGJkqrI8jy8N0cBEJ3o8xDojBCdVsMn3rz5mgFixl0hqXZ2y0Mwi0D7wk1nYQXsoJOCs/PoGJ0esI6qu/rOVhZ9t44agLTOFKZXbAbRPG7DjNObWV+mJEq8GPt/tcXSSIj4O/r61rzZ53pwFKkslmBlggHWvcA3uzV2BHRyGK20UxSnlwow9iyLthuPAxDwHrq0O8yImOuU8xkbaraUWkulTcnltkYxtzTFDXdksUaNmigca9pwtqCJe7vhoAkVUhljqZzhDvqzwCWHwJjtTPwOK1GPhzptO2qAabXVuMK+Eeuhzvfv2GkW45CSh/G6Q== cardno:16_751_940"
        ];
      };
    };
  };

  time.timeZone = "America/Chicago";
}