{
  disk = {
    hdd = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST3500413AS_Z2APBLRN";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          system = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "system";
            };
          };
        };
      };
    };
  };
  zpool = {
    system = {
      type = "zpool";
      options = {
        autotrim = "on";
      };
      rootFsOptions = {
        compression = "zstd";
        "com.sun:auto-snapshot" = "false";
      };
      mountpoint = "/";
      postCreateHook = "zfs snapshot system@blank";
      datasets = {
        persistent = {
          type = "zfs_fs";
          mountpoint = "/persistent";
        };
        "nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        swap = {
          type = "zfs_volume";
          size = "12G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
      };
    };
  };
}
