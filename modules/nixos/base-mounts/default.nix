{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.base-mounts;
in {
  options.united.base-mounts = {
    enable = mkEnableOption "Base-mounts";
  };

  config = mkIf cfg.enable {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [ ];
  };
}