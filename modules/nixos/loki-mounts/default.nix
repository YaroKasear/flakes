{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.loki-mounts;
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

in {
  options.united.loki-mounts = {
    enable = mkEnableOption "loki-mounts";
  };

  config = mkIf cfg.enable {
    age.secrets.davfs-secrets = {
      rekeyFile = secrets-directory + "davfs-secrets.age";
      mode = "600";
    };

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
        "davfs2/secrets".source = config.age.secrets.davfs-secrets.path;
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
      # "/home/yaro/Nextcloud" = {
      #   device = "storage.kasear.net:/mnt/data/user/yaro/cloud";
      #   fsType = "nfs";
      #   options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
      # };
      "/home/yaro/Nextcloud" = {
        device = "https://cloud.kasear.net/remote.php/dav/files/Yaro";
        fsType = "davfs";
        options = [ "rw" "user" "uid=yaro" "noauto" "x-systemd.automount" "_netdev" ];
      };
      "/mnt/containers" = {
        device = "storage.kasear.net:/mnt/data/containers";
        fsType = "nfs";
        options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600"  "_netdev" ];
      };
    };

    systemd.tmpfiles.settings."10-nextcloud-yaro"."/home/yaro/Nextcloud".d = {
      user = "yaro";
      group = "users";
      mode = "0755";
    };

    services = {
      davfs2 = {
        enable = true;
        settings = {
          globalSection.use_locks = false;
          sections = {
            "/home/yaro/Nextcloud" = {
              gui_optimize = true;
            };
          };
        };
      };
      zfs = {
        autoScrub = enabled;
        trim = enabled;
      };
    };
  };
}