{
  disk = {
    ssd = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_960_EVO_500GB_S3X4NB0K140749K";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}