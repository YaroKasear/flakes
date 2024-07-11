{
  disk = {
    ssd = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD40EZRZ-00GXCB0_WD-WCC7K5EV6XH9";
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
      rootFsOptions = {
        compression = "zstd";
        "com.sun:auto-snapshot" = "false";
      };
      mountpoint = "/";
      # postCreateHook = "zfs snapshot system@blank";
      datasets = {
        # persistent = {
        #   type = "zfs_fs";
        #   mountpoint = "/persistent";
        # };
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
