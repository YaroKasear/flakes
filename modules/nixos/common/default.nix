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
      useDHCP = lib.mkDefault true;
    };

    nix.package = pkgs.nixFlakes;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    programs = {
      ssh.startAgent = false;
      zsh.enable = true;
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
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

    system.stateVersion = "unstable";

    systemd.enableEmergencyMode = false;

    users.users.root.hashedPassword = "!";
  };
}
