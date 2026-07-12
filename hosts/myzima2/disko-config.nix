# Example to create a bios compatible gpt partition
# blkid
# /dev/mmcblk0p1: SEC_TYPE="msdos" LABEL_FATBOOT="casaos-boot" LABEL="casaos-boot" UUID="D449-1F65" BLOCK_SIZE="512"  TYPE="vfat"        PARTLABEL="disk-boot_disk-mmc_boot"  PARTUUID="8631a722-24f1-4173-8ffc-3d2715f79ba2"
# /dev/mmcblk0p2:        UUID="5DEA-E591"                                                           BLOCK_SIZE="512"  TYPE="vfat"        PARTLABEL="disk-boot_disk-mmc_ESP"   PARTUUID="070b277c-9a99-4d85-a7a1-15e1774bbb39"
# /dev/mmcblk0p3:        UUID="6b315ba7-2e9f-4fbe-b035-c5c3072966d1"                                BLOCK_SIZE="4096" TYPE="ext4"        PARTLABEL="disk-boot_disk-mmc_root0" PARTUUID="30d3f344-9bd3-4648-afd7-9f12a547d5f4"
# /dev/sda1:             UUID="zruOUg-kP62-dzk2-tU7p-FNN1-Mip1-xmy236"                                                TYPE="LVM2_member" PARTLABEL="disk-data_disk1-sda_pv0"  PARTUUID="cbac53cd-3766-4ce1-b5cd-9f34c971f38b"
# /dev/sdb1:             UUID="5PFVBz-IBT1-1pWY-SWv6-u5TA-zrY5-QD8uVD"                                                TYPE="LVM2_member" PARTLABEL="disk-data_disk2-sdb_pv0"  PARTUUID="be13030d-b038-4bed-8c17-3e5ab4fedcc1"
# /dev/mapper/pool-root: UUID="357b29e8-19f3-43ef-bf34-37fed54abe1f"                                BLOCK_SIZE="4096" TYPE="ext4"
# /dev/mapper/pool-swap: UUID="88e5d900-c4cd-4464-aa14-d305a4580eba"                                                  TYPE="swap"

# ls -laF /dev/disk/by-id/
# lrwxrwxrwx  1 root root   9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR507D0Z           -> ../../sda
# lrwxrwxrwx  1 root root  10 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR507D0Z-part1     -> ../../sda1
# lrwxrwxrwx  1 root root   9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR508KY1           -> ../../sdb
# lrwxrwxrwx  1 root root  10 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR508KY1-part1     -> ../../sdb1
# lrwxrwxrwx  1 root root  10 Oct 11 03:42 dm-name-pool-root                           -> ../../dm-1
# lrwxrwxrwx  1 root root  10 Oct 11 03:42 dm-name-pool-swap                           -> ../../dm-0
#
# ls -laF /dev/mapper/
# crw-------  1 root root 10, 236 Mar 24 15:53 control
# lrwxrwxrwx  1 root root       7 Mar 24 15:53 pool-root -> ../dm-1
# lrwxrwxrwx  1 root root       7 Mar 24 15:53 pool-swap -> ../dm-0
{ lib, ... }:
{
  disko.devices = {

    disk = {
      boot_disk = {
        type = "disk";
        device = lib.mkDefault "/dev/mmcblk0";
        content = {
          type = "gpt";
          partitions = {
            # blkid
            # /dev/mmcblk0p1:
            #                   SEC_TYPE="msdos"
            #                   LABEL_FATBOOT="casaos-boot"
            #                   LABEL="casaos-boot"
            #                   UUID="D449-1F65"
            #                   BLOCK_SIZE="512"
            #                   TYPE="vfat"
            #                   PARTLABEL="disk-boot_disk-mmc_boot"
            #                   PARTUUID="8631a722-24f1-4173-8ffc-3d2715f79ba2"
            boot = {
              name = "mmc_boot";
              size = "1M";
              type = "EF02";
            };
            # blkid
            # /dev/mmcblk0p2:
            #                   UUID="5DEA-E591"
            #                   BLOCK_SIZE="512"
            #                   TYPE="vfat"
            #                   PARTLABEL="disk-boot_disk-mmc_ESP"
            #                   PARTUUID="070b277c-9a99-4d85-a7a1-15e1774bbb39"
            esp = {
              name = "mmc_ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            # blkid
            # /dev/mmcblk0p3:
            #                   UUID="6b315ba7-2e9f-4fbe-b035-c5c3072966d1"
            #                   BLOCK_SIZE="4096"
            #                   TYPE="ext4"
            #                   PARTLABEL="disk-boot_disk-mmc_root0"
            #                   PARTUUID="30d3f344-9bd3-4648-afd7-9f12a547d5f4"
            root = {
              name = "mmc_root0";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                ];
              };
            };
          };
        };
      };

      data_disk1 = {
        type = "disk";
        device = lib.mkDefault "/dev/disk/by-id/ata-ST18000NM000J-2TV103_WR507D0Z";
        content = {
          type = "gpt";
          partitions = {
            # blkid
            # /dev/sda1:
            #               UUID="zruOUg-kP62-dzk2-tU7p-FNN1-Mip1-xmy236"
            #               TYPE="LVM2_member"
            #               PARTLABEL="disk-data_disk1-sda_pv0"
            #               PARTUUID="cbac53cd-3766-4ce1-b5cd-9f34c971f38b"
            root = {
              name = "sda_pv0";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };

      data_disk2 = {
        type = "disk";
        device = lib.mkDefault "/dev/disk/by-id/ata-ST18000NM000J-2TV103_WR508KY1";
        content = {
          type = "gpt";
          partitions = {
            #blkid
            # /dev/sdb1:
            #               UUID="5PFVBz-IBT1-1pWY-SWv6-u5TA-zrY5-QD8uVD"
            #               TYPE="LVM2_member"
            #               PARTLABEL="disk-data_disk2-sdb_pv0"
            #               PARTUUID="be13030d-b038-4bed-8c17-3e5ab4fedcc1"
            root = {
              name = "sdb_pv0";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          # blkid
          # /dev/mapper/pool-swap:
          #                         UUID="88e5d900-c4cd-4464-aa14-d305a4580eba"
          #                         TYPE="swap"
          swap = {
            size = "33G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true; # resume from hiberation from this device
            };
          };
          # blkid
          # /dev/mapper/pool-root:
          #                         UUID="357b29e8-19f3-43ef-bf34-37fed54abe1f"
          #                         BLOCK_SIZE="4096"
          #                         TYPE="ext4"
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/data";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
