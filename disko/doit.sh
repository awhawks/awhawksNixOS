#!/bin/bash

#awhawks@p50:~/awhawksNixOS/disko$ blkid 
#/dev/mapper/vgbig-root: UUID="052263ff-6c0e-48dd-8fce-67bf4461f9bf" BLOCK_SIZE="4096" TYPE="ext4"
#/dev/nvme0n1p1: UUID="WkZUUp-1NBt-fTfs-NPzy-z8wa-xW0C-4EZKsd" TYPE="LVM2_member" PARTLABEL="pv_nvme0n1p1" PARTUUID="2e0708c0-11b8-45f1-8b4d-7367195e6813"
#/dev/sdb1: UUID="y7TBfA-Hwia-OwM6-AIjq-GVz9-SaeQ-hsFBjD" TYPE="LVM2_member" PARTLABEL="pv_sdb1" PARTUUID="66e9e2a0-9c04-43e3-b8be-e0e324478a91"
#/dev/mapper/vgbig-swap: UUID="6e927281-6a79-4b6a-8c8f-6cf6823424e2" TYPE="swap"
#/dev/sda2: UUID="QH5oDg-D2FV-GpH6-W0hq-CkZc-ab49-UGf5XR" TYPE="LVM2_member" PARTLABEL="pv_sda2" PARTUUID="8dff93f6-7b13-46e0-93a0-6d201ccb5065"
#/dev/sda1: LABEL_FATBOOT="BOOT" LABEL="BOOT" UUID="D9C3-D67D" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="boot" PARTUUID="25aa8118-c6b4-4173-a3b7-3f23151227c1"

#awhawks@p50:~/awhawksNixOS/disko$ lsblk
#NAME           MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
#sda              8:0    0 476.9G  0 disk 
#├─sda1           8:1    0   1.9G  0 part /boot/efi
#└─sda2           8:2    0 475.1G  0 part 
#  ├─vgbig-swap 252:0    0    32G  0 lvm  [SWAP]
#  └─vgbig-root 252:1    0   2.3T  0 lvm  /
#sdb              8:16   0 931.5G  0 disk 
#└─sdb1           8:17   0 931.5G  0 part 
#  └─vgbig-root 252:1    0   2.3T  0 lvm  /
#nvme0n1        259:0    0 953.9G  0 disk 
#└─nvme0n1p1    259:1    0 953.9G  0 part 
#  └─vgbig-root 252:1    0   2.3T  0 lvm  /
#awhawks@p50:~/awhawksNixOS/disko$ 



sudo nix run 'github:nix-community/disko#disko-install' \
	-- \
	--flake <flake-url>#<flake-attr> \
	--disk <disk-name> <disk-device>


