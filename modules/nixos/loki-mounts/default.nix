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
    boot.initrd.systemd.services.rollback = {
      description = "Clear root filesystem.";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        "zfs-import-system.service"
      ];
      before = [
        "sysroot.mount"
      ];
      path = with pkgs; [
        zfs
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        zfs rollback -r system@blank && echo "!!! ROOT FILESYSTEM WIPED !!!"
      '';
    };

    disko.devices = ./config.nix;

    environment.persistence."/persistent" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
      ];
      files = [
        "/etc/syskey"
      ];
    };

    fileSystems."/persistent".neededForBoot = true;
  };
}