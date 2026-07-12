# Example to create a bios compatible gpt partition
# blkid
# /dev/mmcblk0p1:                     UUID="59D1-B190"                              BLOCK_SIZE="512"  TYPE="vfat"        PARTLABEL="EFI"  PARTUUID="2ab433dc-92a8-4014-86e9-7ec62e31ff3a"
# /dev/mmcblk0p2: LABEL="root"        UUID="b97a7d4d-da96-4d0b-8982-818cb30011f6"   BLOCK_SIZE="4096" TYPE="ext4"        PARTLABEL="root" PARTUUID="9c5c31e2-2735-433a-8e3e-2184876a6159"
# /dev/sda1:                          UUID="INUwiz-h1jp-0TTE-PVnE-i2kf-2PI5-6KkaeD"                   TYPE="LVM2_member"                  PARTUUID="9e982752-17c0-49f8-b1d2-cd164302c103"
# /dev/sdb1:                          UUID="JLRvrh-GMoZ-it5F-8DmX-6qgJ-WB8R-SUZ8Li"                   TYPE="LVM2_member"                  PARTUUID="73e1b670-8cf7-48ae-8844-3348eb5b6c15"
# /dev/mapper/nixos_vg-nixos_lv_root: UUID="aebcc0c9-c680-4cab-9712-345eeb177ad7"   BLOCK_SIZE="4096" TYPE="ext4"
#
# ls -laF /dev/disk/by-id/
# lrwxrwxrwx  1 root root   9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR50M4K6           -> ../../sda
# lrwxrwxrwx  1 root root   9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR50N5MF           -> ../../sdb
# lrwxrwxrwx  1 root root  10 Oct 11 03:42 dm-name-nixos_vg-nixos_lv_root              -> ../../dm-0


# cat /etc/fstab
# /dev/disk/by-uuid/b97a7d4d-da96-4d0b-8982-818cb30011f6 /     ext4 x-initrd.mount        0 1
# /dev/disk/by-uuid/59D1-B190                            /boot vfat fmask=0077,dmask=0077 0 2
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
            #                   UUID="59D1-B190"
            #                   BLOCK_SIZE="512"
            #                   TYPE="vfat"
            #                   PARTLABEL="EFI"
            #                   PARTUUID="2ab433dc-92a8-4014-86e9-7ec62e31ff3a"
            # cat /etc/fstab
            # /dev/disk/by-uuid/59D1-B190                            /boot vfat fmask=0077,dmask=0077 0 2
            esp = {
              name = "mmc_ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            # blkid
            # /dev/mmcblk0p2:
            #                   LABEL="root"
            #                   UUID="b97a7d4d-da96-4d0b-8982-818cb30011f6"
            #                   BLOCK_SIZE="4096"
            #                   TYPE="ext4"
            #                   PARTLABEL="root"
            #                   PARTUUID="9c5c31e2-2735-433a-8e3e-2184876a6159"
            # cat /etc/fstab
            # /dev/disk/by-uuid/b97a7d4d-da96-4d0b-8982-818cb30011f6 /     ext4 x-initrd.mount        0 1
            root = {
              name = "mmc_root0";
              size = "100%";
              type = "8300";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "x-initrd.mount"
                ];
              };
            };
          };
        };
      };

      data_disk1 = {
        # ls -laF /dev/disk/by-id/
        # lrwxrwxrwx  1 root root   9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR50M4K6           -> ../../sda
        type = "disk";
        device = lib.mkDefault "/dev/disk/by-id/ata-ST18000NM000J-2TV103_WR50M4K6";
        content = {
          type = "gpt";
          partitions = {
            # blkid
            # /dev/sda1:
            #               UUID="INUwiz-h1jp-0TTE-PVnE-i2kf-2PI5-6KkaeD"
            #               TYPE="LVM2_member"
            #               PARTUUID="9e982752-17c0-49f8-b1d2-cd164302c103"
            root = {
              name = "sda_pv0";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "nixos_vg";
              };
            };
          };
        };
      };

      data_disk2 = {
        # ls -laF /dev/disk/by-id/
        # lrwxrwxrwx  1 root root   9 Oct 11 03:42 ata-ST18000NM000J-2TV103_WR50N5MF           -> ../../sdb
        type = "disk";
        device = lib.mkDefault "/dev/disk/by-id/ata-ST18000NM000J-2TV103_WR50N5MF";
        content = {
          type = "gpt";
          partitions = {
            #blkid
            # /dev/sdb1:
            #               UUID="JLRvrh-GMoZ-it5F-8DmX-6qgJ-WB8R-SUZ8Li"
            #               TYPE="LVM2_member"
            #               PARTUUID="73e1b670-8cf7-48ae-8844-3348eb5b6c15"
            root = {
              name = "sdb_pv0";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "nixos_vg";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      nixos_vg = {
        type = "lvm_vg";
        lvs = {
          # blkid
          # /dev/mapper/nixos_vg-nixos_lv_root:
          #                                     UUID="aebcc0c9-c680-4cab-9712-345eeb177ad7"
          #                                     BLOCK_SIZE="4096"
          #                                     TYPE="ext4"
          # ls -laF /dev/disk/by-id/
          # lrwxrwxrwx  1 root root  10 Oct 11 03:42 dm-name-nixos_vg-nixos_lv_root              -> ../../dm-0
          nixos_lv_root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/awhawks/mnt";
              mountOptions = [
                "rw"
                "relatime"
              ];
            };
          };
        };
      };
    };
  };
}
