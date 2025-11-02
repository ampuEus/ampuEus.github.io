---
title: Storage filesystems cheatsheet
description: Some notes about OS filesystems
# author:
# authors:
date: 2025-11-02 16:24:00 +0200
# last_modified_at: 2025-11-01 16:24:00 +0200
categories: [Programming]
tags: [cheatsheet, filesystem]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/filesystem/filesystem.svg
  # lqip:
  # alt:
---

## Table of contents

- [Table of contents](#table-of-contents)
- [Description](#description)
- [Comparison File and Volume Size Limits](#comparison-file-and-volume-size-limits)
- [Portability (Cross-Platform Support)](#portability-cross-platform-support)
- [Reliability \& Data Protection](#reliability--data-protection)
- [Performance](#performance)

## Description

When using storage drives (USB sticks, SD cards, external HDD/SSD), the file system determines how data is organized, stored, and accessed. Affecting compatibility, speed, and reliability.

## Comparison File and Volume Size Limits

| File System | Max File Size | Max Volume Size | Notes                                                                 |
|-------------|---------------|-----------------|-----------------------------------------------------------------------|
| FAT32       | 4 GB          | 2 TB            | Very common, works on almost any device, but limited by 4 GB file cap |
| exFAT       | 16 EB         | 128 PB          | Great for large files, supported by most modern OSes                  |
| NTFS        | 16 EB         | 16 EB           | Windows-native, handles large files well                              |
| ext4        | 16 TB         | 1 EB            | Linux-native, high performance, journaling support                    |
| APFS        | 8 EB          | 8 EB            | macOS-native, optimized for SSDs                                      |

>
>| Acronym | Name     | Size    |
>|---------|----------|---------|
>| GB      | Gigabyte | 1024 MB |
>| TB      | Terabyte | 1024 GB |
>| PB      | Petabyte | 1024 TB |
>| EB      | Exabyte  | 1024 PB |
>
{: .prompt-info }

## Portability (Cross-Platform Support)

| File System | Windows | macOS               |  Linux                   |
|-------------|---------|---------------------|--------------------------|
| FAT32       | ✅     | ✅                  | ✅                      |
| exFAT       | ✅     | ✅                  | ✅                      |
| NTFS        | ✅     | Read-only by default | ✅ (RW with ntfs-3g)    |
| ext4        | ❌     | ❌                  | ✅                      |
| APFS/HFS+   | ❌     | ✅                  | Partial (drivers needed) |

## Reliability & Data Protection

- **Journaling** (ext4, NTFS, APFS, HFS+): Keeps a transaction log to prevent corruption after power loss.
- **Non-journaling** (FAT32, exFAT): Faster on simple devices but more prone to corruption.

## Performance

- SSDs benefit from file systems optimized for flash memory (e.g., APFS, exFAT).
- Mechanical HDDs often perform consistently across modern FS types.
