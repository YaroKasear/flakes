{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.desktop-mounts;
in {
  options.united.desktop-mounts = {
    enable = mkEnableOption "Desktop-mounts";
  };

  config = mkIf cfg.enable {
    united = {
      base-mounts.enable = true;
      game-mounts.enable = true;
      media-mounts.enable = true;
    };

    fileSystems."/home/yaro" = {
      device = "storage.kasear.net:/mnt/data/user/yaro/nixos";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };

    swapDevices = [ ];
  };
}