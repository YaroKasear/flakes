{ config, lib, pkgs, inputs, ... }:

{
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

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    overlays = [ inputs.nixos-apple-silicon.overlays.apple-silicon-overlay ];
  };

  united = {
    common.enable = true;
    yaro.enable = true;
  };

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };
}