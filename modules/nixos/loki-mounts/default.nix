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
          "/etc/syskey"
          "/var/db/sudo/lectured/1000"
          "/var/cache/regreet/cache.toml"
          "/var/lib/lightdm/.cache/lightdm-gtk-greeter/state"
        ];
      };
    };

    fileSystems = {
      "/persistent".neededForBoot = true;
      "/home/yaro/Nextcloud" = {
        device = "storage.kasear.net:/mnt/data/user/yaro/cloud";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "_netdev" ];
      };
      "/mnt/containers" = {
        device = "storage.kasear.net:/mnt/data/containers";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "_netdev" ];
      };
    };

    systemd.tmpfiles.settings."10-nextcloud-yaro"."/home/yaro/Nextcloud".d = {
      user = "yaro";
      group = "users";
      mode = "0755";
    };

    services.zfs = {
      autoScrub = enabled;
      trim = enabled;
    };
  };
}