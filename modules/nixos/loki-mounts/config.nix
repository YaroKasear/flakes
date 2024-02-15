{
  # disk = {
  #   ssd = {
  #     device = "/dev/disk/by-id/nvme-Samsung_SSD_960_EVO_500GB_S3X4NB0K140749K";
  #     type = "disk";
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #         esp = {
  #           type = "EF00";
  #           size = "1G";
  #           content = {
  #             type = "filesystem";
  #             format = "vfat";
  #             mountpoint = "/boot";
  #           };
  #         };
  #         root = {
  #           size = "100%";
  #           content = {
  #             type = "filesystem";
  #             format = "ext4";
  #             mountpoint = "/";
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
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
        autotrim = "on";
        compression = "zstd";
        "com.sun:auto-snapshot" = "false";
      };
      mountpoint = "/";
      postCreateHook = "zfs snapshot system@blank";
      datasets = {
        swap = {
          type = "zfs_volume";
          size = "48G";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        };
      };
    };
  };
}