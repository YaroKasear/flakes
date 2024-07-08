{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.phobos-mounts;

in {
  options.united.phobos-mounts = {
    enable = mkEnableOption "phobos-mounts";
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

    environment = {
      etc = {
        "ssh/ssh_host_ed25519_key".source = "/persistent/etc/ssh/ssh_host_ed25519_key";
        "ssh/ssh_host_ed25519_key.pub".source = "/persistent/etc/ssh/ssh_host_ed25519_key.pub";
      };
      persistence."/persistent" = {
        hideMounts = true;
        directories = [
          "/etc/NetworkManager/system-connections/"
          "/run/log/journal"
          "/var/lib/nixos"
          "/var/log"
        ];
        files = [
          "/var/db/sudo/lectured/1000"
        ];
      };
    };

    fileSystems = {
      "/persistent".neededForBoot = true;
    };

    services.zfs.autoScrub = enabled;
  };
}