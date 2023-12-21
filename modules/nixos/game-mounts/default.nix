{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.game-mounts;
in {
  options.united.game-mounts = {
    enable = mkEnableOption "Game-mounts";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/games" = {
      device = "storage.kasear.net:/mnt/data/storage/games";
      fsType = "nfs";
      options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
    };
  };
}