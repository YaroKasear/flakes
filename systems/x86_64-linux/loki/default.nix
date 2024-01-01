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
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    tmp.useTmpfs = true;
  };

  united.common.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    polkit_gnome
    pavucontrol
    pulseaudio
    yubikey-personalization
    nfs-utils
    nix-diff
  ];

  fileSystems."/mnt/containers" = {
    device = "storage.kasear.net:/mnt/data/containers";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
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
    enableRedistributableFirmware = lib.mkDefault true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "loki";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
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
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
  };

  programs = {
    zsh.enable = true;
    ssh.startAgent = false;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
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
    kmscon.enable = false;
    wayland.enable = true;
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

  services = {
    xserver = {
      enable = !config.united.wayland.enable;
      layout = "us";
      displayManager.lightdm.enable = !config.united.wayland.enable;
      windowManager.i3 = {
        enable = true;
      };
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    gpm.enable = false;
    openssh = {
      enable = true;
    };
    udev.packages = [
      pkgs.yubikey-personalization
    ];
    pcscd.enable = true;
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  system.stateVersion = "23.05";

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
