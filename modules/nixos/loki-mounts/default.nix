{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.loki-mounts;
in {
  options.united.loki-mounts = {
    enable = mkEnableOption "loki-mounts";
  };

  config = mkIf cfg.enable {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      neededForBoot = true;
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [ ];
  };
}