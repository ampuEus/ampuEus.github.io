---
title: How to manage external drives in Linux - Mount, unmount and format
description: Learn how to mount, unmount, and format external drives in Linux safely.
# author:
# authors:
date: 2025-11-09 10:17:00 +0200
# last_modified_at: 2025-11-09 10:17:00 +0200
categories: [Programming, Filesystem]
tags: [how to]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/filesystem/mount_format_unmount.svg
  # lqip:
  # alt:
---

External drives like USB sticks, SD cards, or SSDs don’t automatically become accessible after connecting them to a Linux system. Before you can use them, you need to **mount** the device linking its filesystem to your directory tree.

This guide explains how to **mount**, **unmount**, and **format** storage devices safely, along with useful troubleshooting tips.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Mount a memory drive](#mount-a-memory-drive)
  - [Step 1: Detect the drive](#step-1-detect-the-drive)
  - [Step 2: Create mount point](#step-2-create-mount-point)
  - [Step 3: Mount the drive](#step-3-mount-the-drive)
  - [Step 4: Access drive data](#step-4-access-drive-data)
  - [\[Extra\] Make the mount permanent](#extra-make-the-mount-permanent)
  - [Troubleshooting](#troubleshooting)
    - [NTFS Filesystem Unsupported](#ntfs-filesystem-unsupported)
- [Unmount a memory drive](#unmount-a-memory-drive)
- [Eject a memory drive](#eject-a-memory-drive)
- [Format a memory drive](#format-a-memory-drive)

## Mount a memory drive

When you plug an external device into your Linux system, it creates a new block device file in the `/dev/` directory. However, you can’t use it. First, you need to mount it.

### Step 1: Detect the drive

To see the device name, run:

```shell
lsblk
```

Output:

```shell
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    1  7.4G  0 disk
└─sda1        8:1    1  7.4G  0 part
mmcblk0     179:0    0 58.2G  0 disk
├─mmcblk0p1 179:1    0  512M  0 part /boot/firmware
└─mmcblk0p2 179:2    0 57.7G  0 part /
```

In this case I plugged a 8 GB USB and Linux named *sda*. Also you can see that **MOUNTPOINTS** parameter **is empty because the device isn't mounted**.

>If you want to get detailed partition information, you can use `sudo fdisk -l`.
{: .prompt-tip }

### Step 2: Create mount point

On Linux systems by convention there are two places to mount external devices `/mnt` and `/media`. The modern behavior is to use on this way:

- `/media`: Removable drives are usually **mounted automatically** when plugged in, handled by systemd, udisks or similar.
- `/mnt`: Remains for **manual mounts**, often empty by default unless explicitly used.

So I am going to create a folder for mount on `/mnt`:

```shell
sudo mkdir /mnt/usb-sda1
```

### Step 3: Mount the drive

Now you can mount the device partition on previously created mount point:

```shell
sudo mount /dev/sda1 /mnt/usb-sda1
```

To test if the USB if mounted corrected, run:

```shell
mount | grep sda1
```

Output:

```shell
/dev/sda1 on /mnt/usb-sda1 type vfat (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,errors=remount-ro)
```

>You can use other commands `df -h` or `lsblk` and check **Mounted on** or **MOUNTPOINTS** respectively.
{: .prompt-info }

### Step 4: Access drive data

Finally, you have access to the device and start using it.

```shell
cd /mnt/usb-sda1
```

### [Extra] Make the mount permanent

To maintain the device mounted after system reboot you need to edit `/etc/fstab` file adding this line:

```shell
# Generic command:
<device partition or UUID>  <mount point> <filesystem type> <mount options> <dump utility flag> <fsck order at boot>

# For this example case:
/dev/sda1           /mnt/usb-sda1   vfat         defaults    0    0
```

>**Use** the USB's **UUID** in `/etc/fstab` **instead of raw device partition name**, which can change if multiple USB drives are connected.
{: .prompt-warning }

To use device `UUID` make the following:

```shell
 ls -l /dev/disk/by-uuid/*
```

Output:

```shell
lrwxrwxrwx 1 root root 10 Sep 22 09:46 /dev/disk/by-uuid/647A-2882 -> ../../sda1
lrwxrwxrwx 1 root root 15 Sep 22 09:17 /dev/disk/by-uuid/d4cc7d63-da78-48ad-9bdd-64ffbba449a8 -> ../../mmcblk0p2
lrwxrwxrwx 1 root root 15 Sep 22 09:17 /dev/disk/by-uuid/EC36-4DE1 -> ../../mmcblk0p1
```

Now change the `/etc/fstab` file's line with:

```shell
/dev/disk/by-uuid/647A-2882           /mnt/usb-sda1   vfat         defaults    0    0
```

### Troubleshooting

#### NTFS Filesystem Unsupported

Normally, **NTFS filesystem isn't supported by default**, so if to attempt to mount a device with that format you will see this error:

```shell
mount: /mnt/usb-sdx: no medium found on /dev/sdx.
```

The **solution** is to **install** `ntfs-3g` package, which adds NTFS read/write support for Linux systems.

## Unmount a memory drive

To unmount a device execute the following:

```shell
umount /mnt/usb-sda1
```

>To unmount a device, you need to be sure that no process is using it. Otherwise you will see an error like this: `umount: /mnt/usb-sda1: target is busy`.
{: .prompt-warning }

## Eject a memory drive

```shell
sudo eject /dev/sda
```

## Format a memory drive

**To format** a external device **it must be unmounted**. On Linux exits the `mkfs` utility to format devices. To know how many format options you have use the autocomplete:

```shell
user@hostname:~ $ mkfs
mkfs         mkfs.cramfs  mkfs.ext2    mkfs.ext4    mkfs.minix   mkfs.ntfs
mkfs.bfs     mkfs.exfat   mkfs.ext3    mkfs.fat     mkfs.msdos   mkfs.vfat
```

Example command:

```shell
sudo mkfs.exfat /dev/sda1
```

Output:

```shell
exfatprogs version : 1.2.0
Creating exFAT filesystem(/dev/sda1, cluster size=32768)

Writing volume boot record: done
Writing backup volume boot record: done
Fat table creation: done
Allocation bitmap creation: done
Upcase table creation: done
Writing root directory entry: done
Synchronizing...

exFAT format complete!
```
