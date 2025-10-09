# Example to create a bios compatible gpt partition
# /dev/mmcblk0p1:         UUID="D0C9-38E1"                            BLOCK_SIZE="512"  TYPE="vfat" PARTLABEL="EFI"  PARTUUID="e3b65216-173c-4d94-8424-8420fe371112"
# /dev/mmcblk0p2:         UUID="71fdd98d-59e7-4e51-97a2-bea6e3eb209b" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="root" PARTUUID="a3f7eb20-7e33-4475-a6c8-74d03136d127"
# /dev/sda1:              UUID="eb1aa8fa-b07c-4d7c-86a4-769614d55317" BLOCK_SIZE="4096" TYPE="ext4"                  PARTUUID="e4023c9b-d0a3-4ac3-b7b7-238f1827170f"
# /dev/sdb1:              UUID="C177-FF48"                            BLOCK_SIZE="512"  TYPE="vfat" PARTLABEL="EFI"  PARTUUID="1b24c856-ed95-421b-8466-b74db0dab53b"
# /dev/sdb2:              UUID="8086280b-de86-40a5-86d6-5e4dbd812055" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="root" PARTUUID="74c3f6e9-1634-445a-b0f0-4f7414f1880f"
# /dev/sdb3: LABEL="swap" UUID="ddeebc33-a5c1-4f3f-bb71-d4f130259513"                   TYPE="swap"                  PARTUUID="d3abc411-36bf-4efd-a0a0-3f51356f246a"
# root@nixos:/]# ls -lF /dev/disk/by-id/
# lrwxrwxrwx 1 root root  9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR507D0Z -> ../../sda
# lrwxrwxrwx 1 root root  9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR508KY1 -> ../../sdb
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
            boot = {
              name = "mmc_boot";
              size = "1M";
              type = "EF02";
            };
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
          swap = {
            size = "33G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true; # resume from hiberation from this device
            };
          };
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
