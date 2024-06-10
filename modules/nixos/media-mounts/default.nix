{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.media-mounts;
in {
  options.united.media-mounts = {
    enable = mkEnableOption "Media-mounts";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/music" = {
      device = "storage.kasear.net:/mnt/data/storage/music";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };

    fileSystems."/mnt/video" = {
      device = "storage.kasear.net:/mnt/data/storage/video";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };

    fileSystems."/mnt/pictures" = {
      device = "storage.kasear.net:/mnt/data/storage/pictures";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };
  };
}