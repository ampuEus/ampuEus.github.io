---
title: What is RAID technology
description:
# author:
# authors:
date: 2025-11-16 11:40:00 +0200
# last_modified_at: 2025-11-16 11:40:00 +0200
categories: [Programming, Filesystem]
tags: [what is, raid]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/others/raid_rack-ia.png
  # lqip:
  alt: Example of storage servers with hard disk drives (generated with IA)
---

## Table of contents

- [Table of contents](#table-of-contents)
- [Description](#description)
- [Previous basic concepts](#previous-basic-concepts)
- [RAID 0: Striping](#raid-0-striping)
- [RAID 1: Mirroring](#raid-1-mirroring)
- [RAID 2 : Bit-level striping + Dedicated *Hamming code* parity](#raid-2--bit-level-striping--dedicated-hamming-code-parity)
- [RAID 3 : Byte-level striping + Dedicated parity](#raid-3--byte-level-striping--dedicated-parity)
- [RAID 4: Block-level striping + Dedicated parity](#raid-4-block-level-striping--dedicated-parity)
- [RAID 5: Block-level striping + Distributed parity](#raid-5-block-level-striping--distributed-parity)
- [RAID 6: Block-level striping + Double distributed parity](#raid-6-block-level-striping--double-distributed-parity)
- [\[Extra\] Some Nested RAIDs](#extra-some-nested-raids)
  - [RAID 10 (1+0): Speed + Redundancy](#raid-10-10-speed--redundancy)
  - [RAID 50 (5+0): Parity Across stripes](#raid-50-50-parity-across-stripes)
  - [RAID 0+1: Striped mirrors](#raid-01-striped-mirrors)
- [Useful tools](#useful-tools)

## Description

RAID (**R**edundant **A**rray of **I**nexpensive **D**isks) uses two or more drives in parallel to **improve speed and/or reliability**. It offers different *levels* optimized for various needs. **These levels aren’t standardized, so implementations may vary**.

>This is in contrast to the previous concept of highly reliable mainframe disk drives known as SLED (**S**ingle **L**arge **E**xpensive **D**isk).
{: .prompt-info }

## Previous basic concepts

- **Data striping** is a technique where data is split into chunks and spread across multiple disk drives. Instead of storing a whole file on one disk, the system divides it into blocks and writes each block to a different disk in sequence.
- **Disk mirroring** is a data storage technique where identical copies of data are written to two or more disks simultaneously.
- **Parity bit** is a simple error-checking tool used in data storage and transmission. It adds a small piece of extra information that helps verify whether the data is correct.

## RAID 0: Striping

Requires a minimum of 2 drives to implement.

The data is subdivided (*striped*) and written on the data disks.

![RAID 0 diagram](/assets/img/filesystem/raid/raid0_light.svg){: .dark }
![RAID 0 diagram](/assets/img/filesystem/raid/raid0_dark.svg){: .light }

| Advantages                                       | Disadvantages                                                       | Best Uses                                |
|--------------------------------------------------|---------------------------------------------------------------------|------------------------------------------|
| I/O performance is greatly improved by striped disk array | NO fault-tolerant                                          | Any application requiring high bandwidth |
| No parity calculation overhead is involved       | Failure of one drive will result in all data in an array being lost | Video Production and Editing             |
| Very simple design                               | NO for critical process                                             | Image Editing                            |
| Easy to implement                                |                                                                     |                                          |

## RAID 1: Mirroring

Requires a minimum of 2 drives to implement.

![RAID 1 diagram](/assets/img/filesystem/raid/raid1_light.svg){: .dark }
![RAID 1 diagram](/assets/img/filesystem/raid/raid1_dark.svg){: .light }

| Advantages                                   | Disadvantages              | Best Uses                                        |
|----------------------------------------------|----------------------------|--------------------------------------------------|
| Fast reads and reliable write                | Uses double the disk space | Any application requiring very high availability |
| Full data backup—easy recovery after failure | Software setups may not allow easy disk swap (Hardware implementation recommended) | Accounting  |
| Easy to set up and manage                    |                            | Payroll                                          |

## RAID 2 : Bit-level striping + Dedicated *Hamming code* parity

Each data bit is stored across multiple data disks, while its Hamming Code error correction (ECC) is saved on separate ECC disks. During reading, the ECC checks for accuracy and can fix errors from a single faulty disk.

![RAID 2 diagram](/assets/img/filesystem/raid/raid2_light.svg){: .dark }
![RAID 2 diagram](/assets/img/filesystem/raid/raid2_dark.svg){: .light }

| Advantages                                    | Disadvantages                                               |
|-----------------------------------------------|-------------------------------------------------------------|
| Fixes data errors on the fly                  | Needs many error-checking (ECC) disks for small data sizes  |
| Very high data transfer speeds                | Very expensive, only worth it for extreme speed needs       |
| Better efficiency with more data disks        | Overall transaction speed equals that of a single disk      |
| Simpler controller design than RAID 3, 4, & 5 | Not used commercially. Not practical for real-world systems |

## RAID 3 : Byte-level striping + Dedicated parity

Requires at least 3 drives to implement.

The data block is subdivided (*striped*) and written on the data disks. Then Stripe parity is created during write operations, saved on a parity disk, and used during reads to verify or recover data.

![RAID 3 diagram](/assets/img/filesystem/raid/raid3_light.svg){: .dark }
![RAID 3 diagram](/assets/img/filesystem/raid/raid3_dark.svg){: .light }

| Advantages                              | Disadvantages                               | Best Uses                                 |
|-----------------------------------------|---------------------------------------------|-------------------------------------------|
| Very fast read and write speeds         | Slower transaction rate, like a single disk | Any application requiring high throughput |
| Keeps working well even if a disk fails | Complex controller design                   | Video production & live streaming         |
| Efficient use of disks                  | Hard to set up with software RAID           | Image and video editing                   |

## RAID 4: Block-level striping + Dedicated parity

Require a minimum of 3 drives to implement.

Each data block is stored on a separate disk. Parity for blocks in the same position (rank) is created during writes, saved on a parity disk, and used during reads to verify or recover data.

![RAID 4 diagram](/assets/img/filesystem/raid/raid4_light.svg){: .dark }
![RAID 4 diagram](/assets/img/filesystem/raid/raid4_dark.svg){: .light }

| Advantages                                 | Disadvantages                                              |
|--------------------------------------------|------------------------------------------------------------|
| Very fast read performance                 | Complex controller design                                  |
| Efficient disk usage (low parity overhead) | Slow write speed and poor write performance                |
| High overall read throughput               | Hard and slow to rebuild data after disk failure           |
|                                            | Reading a single block is as slow as reading from one disk |

## RAID 5: Block-level striping + Distributed parity

Require a minimum of 3 drives to implement.

RAID 5 uses block-level striping with distributed parity. Parity data is spread across all drives, allowing the system to keep working even if one drive fails. Read and write operations are shared across multiple disks for better performance.

![RAID 5 diagram](/assets/img/filesystem/raid/raid5_light.svg){: .dark }
![RAID 5 diagram](/assets/img/filesystem/raid/raid5_dark.svg){: .light }

| Advantages                                 | Disadvantages                              | Best Uses                                     |
|--------------------------------------------|--------------------------------------------|-----------------------------------------------|
| Fastest read performance                   | Medium slowdown if a disk fails            | File & application servers                    |
| Decent write speed                         | Very complex controller design             | Database servers                              |
| Efficient disk usage (low parity overhead) | Single block reads are as slow as one disk | Web, email, and news servers                  |
| Good overall data transfer rate            |                                            | Intranet servers, general-purpose RAID setups |

## RAID 6: Block-level striping + Double distributed parity

Requires a minimum of 4 drives to implement.

To protect against two simultaneous disk failures, RAID 6 uses two separate parity calculations, each based on a different algorithm. This dual-parity setup ensures stronger fault tolerance.

![RAID 6 diagram](/assets/img/filesystem/raid/raid6_light.svg){: .dark }
![RAID 6 diagram](/assets/img/filesystem/raid/raid6_dark.svg){: .light }

| Advantages                                         | Disadvantages                                          | Best Uses                                  |
|----------------------------------------------------|--------------------------------------------------------|--------------------------------------------|
| Dual parity offers extra fault tolerance           | Complex controller design                              | File & application servers                 |
| Data is striped across drives for efficient access | High overhead for parity calculations                  | Database servers                           |
| Protects against multiple bad block failures       | Slower writes unless using specialized hardware (ASIC) | Web and email servers                      |
| Reliable even in degraded mode                     | Needs at least two extra drives (N+2 setup)            | Intranet servers, mission-critical systems |

## [Extra] Some Nested RAIDs

### RAID 10 (1+0): Speed + Redundancy

Requires a minimum of 4 drives to implement.

![RAID 10 diagram](/assets/img/filesystem/raid/raid10_light.svg){: .dark }
![RAID 10 diagram](/assets/img/filesystem/raid/raid10_dark.svg){: .light }

### RAID 50 (5+0): Parity Across stripes

Requires a minimum of 6 drives to implement.

![RAID 50 diagram](/assets/img/filesystem/raid/raid50_light.svg){: .dark }
![RAID 50 diagram](/assets/img/filesystem/raid/raid50_dark.svg){: .light }

### RAID 0+1: Striped mirrors

Requires a minimum of 4 drives to implement.

![RAID 0 + 1 diagram](/assets/img/filesystem/raid/raid01_light.svg){: .dark }
![RAID 0 + 1 diagram](/assets/img/filesystem/raid/raid01_dark.svg){: .light }

## Useful tools

- [RAID Calculator](https://www.raid-calculator.com/){:target="_blank"}
- [Synology RAID Calculator](https://www.synology.com/en-us/support/RAID_calculator?drives=8%20TB%7C8%20TB%7C8%20TB%7C8%20TB&raid=RAID_1%7CRAID_6){:target="_blank"}
