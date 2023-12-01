{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hw.nix
  ];

  nixpkgs.config.allowUnfree = true;

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

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
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
  };

  networking = {
    hostName = "loki"; 
    networkmanager.enable = true;  
  };

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
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
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.yubico = {
      enable = true;
      mode = "client";
      id = "94905";
      control = "required";
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      videoDrivers = ["nvidia"];
      displayManager.lightdm.enable = true;
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
    gpm.enable = true;
    openssh = {
      enable = true;
    };
    udev.packages = [
      pkgs.yubikey-personalization
    ];
    pcscd.enable = true;
  };

  programs = {
    zsh.enable = true;
    ssh.startAgent = false;
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  users.users.yaro = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "networkmanager" "lp"]; 
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim 
    wget
    polkit_gnome
    pavucontrol
    yubikey-personalization
    nfs-utils
  ];

  system.stateVersion = "23.05"; 
}

