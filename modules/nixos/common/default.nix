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
      kernelPackages = pkgs.linuxPackages_zen;
      tmp.useTmpfs = true;
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    environment.systemPackages = with pkgs; [
      wget
      polkit_gnome
      pavucontrol
      pulseaudio
      yubikey-personalization
      nfs-utils
      nix-diff
    ];

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      enableRedistributableFirmware = lib.mkDefault true;
    };

    i18n.defaultLocale = "en_US.UTF-8";

    networking = {
      useDHCP = lib.mkDefault true;
    };

    nix.package = pkgs.nixFlakes;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    programs = {
      zsh.enable = true;
      ssh.startAgent = false;
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
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

    system.stateVersion = "unstable";

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

    united = {
      wayland.enable = true;
    };
  };
}