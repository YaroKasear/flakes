{
  disk = {
    ssd = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_960_EVO_500GB_S3X4NB0K140749K";
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
          swap = {
            size = "48G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          system = {
            size = "208G";
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
        # "games" = {
        #   type = "zfs_fs";
        #   mountpoint = "/games";
        # };
        # persistent = {
        #   type = "zfs_fs";
        #   mountpoint = "/persistent";
        # };
        "nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
        # swap = {
        #   type = "zfs_volume";
        #   size = "48G";
        #   content = {
        #     type = "swap";
        #     randomEncryption = true;
        #   };
        # };
      };
    };
  };
}
