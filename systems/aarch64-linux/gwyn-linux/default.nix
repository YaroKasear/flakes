{ config, lib, pkgs, inputs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  hardware.asahi = {
    extractPeripheralFirmware = false;
    useExperimentalGPUDriver = true;
  };

  nixpkgs.overlays = [ inputs.nixos-apple-silicon.overlays.apple-silicon-overlay ];

  united = {
    common.enable = true;
    yaro.enable = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  system.stateVersion = "23.05";
}