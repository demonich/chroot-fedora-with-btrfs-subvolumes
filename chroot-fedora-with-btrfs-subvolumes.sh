#!/bin/bash

# ---start---
# check partitions
fdisk -l
# or better yet, don't suffer and use a GUI application to do it, such as gparted or gnome-disk-utility

# in /dev/sdaX, X - is the number of your partitions
# for example, imagine that we have this structure
# /dev/sda1         /boot/efi
# /dev/sda2         /boot
# /dev/sda3         swap
# /dev/sda4         / and /home

# --- mount ---
mount /dev/sda4 /mnt/ -t btrfs -o subvol=root
mount /dev/sda4 /mnt/home -t btrfs -o subvol=home #if you want to solve just grub problems, this is not necessary
mount /dev/sda2 /mnt/boot
mount /dev/sda1 /mnt/boot/efi
mount --bind /dev /mnt/dev
mount -t proc /proc /mnt/proc
mount -t sysfs /sys /mnt/sys
mount -t tmpfs tmpfs /mnt/run
mkdir -p /mnt/run/systemd/resolve/
echo 'nameserver 1.1.1.1' > /mnt/run/systemd/resolve/stub-resolv.conf
chroot /mnt

# --- unmount ---
# exit # from chroot, if you didn't yet
# umount /mnt/boot
# umount /mnt/sys
# umount /mnt/proc
# umount /mnt/sys
# umount /mnt/run
# umount /mnt

# --- bonus ---
# let's fix grub problems
# grub2-editenv create
# grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
