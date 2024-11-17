{ config, lib, ... }:
with lib;

let

  cfg = config.united.audiobookshelf;

in
{
  options.united.audiobookshelf = {
    enable = mkEnableOption "AudioBookShelf";
  };

  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
      port = 6502;
      openFirewall = true;
    };

    fileSystems."/var/lib/audiobookshelf" = {
      device = "storage.kasear.net:/mnt/data/server/phobos/audiobookshelf";
      fsType = "nfs4";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };

    users = {
      users.audiobookshelf.uid = 3006;
      groups.audiobookshelf.gid = 3008;
    };
  };
}
