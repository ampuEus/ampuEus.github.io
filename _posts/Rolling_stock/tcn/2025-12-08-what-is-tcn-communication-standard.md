---
title: What is Train Communication Network (TCN) railway communication standard
description:
# author:
# authors:
date: 2025-12-08 10:23:47 +0200
# last_modified_at: 2025-12-08 10:23:47 +0200
categories: [Rolling stock, TCN]
tags: [what is, iec61375]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/rolling_stock/tcn/tcn_train_example_scheme.svg
  # lqip:
  alt: Example of all TCN communication protocols
---

## Table of contents

- [Table of contents](#table-of-contents)
- [Definition](#definition)
- [TCN standard overview](#tcn-standard-overview)
- [Core concepts](#core-concepts)
  - [Train composition](#train-composition)
  - [Network levels: Train backbone \& Consist network](#network-levels-train-backbone--consist-network)
    - [Train backbone](#train-backbone)
    - [Consist network](#consist-network)
  - [Communication technology classes](#communication-technology-classes)
- [Train inauguration as part of train backbone](#train-inauguration-as-part-of-train-backbone)
- [Communication patterns](#communication-patterns)
- [Communication data clases](#communication-data-clases)
  - [Service paramentes](#service-paramentes)

## Definition

**Train Communication Network** (TCN) is an international **standard network used for communication within train**. TCN is specified by the **IEC 61375** standard.

The **scope** is to ensure **interoperability** and reliable communication **between devices** on the train **and** between multiple **trains**.

## TCN standard overview

![TCN standard mindmap](/assets/img/rolling_stock/tcn/tcn_standard_mindmap.svg)

## Core concepts

### Train composition

Train is a composition of closed trains, each closed train having one or several consists and each consist having one or several vehicles.

>With a maximum number of 63 vehicles.
{: .prompt-warning }

![TCN train structure](/assets/img/rolling_stock/tcn/tcn_train_structure_white_background.svg){: .light}
![TCN train structure](/assets/img/rolling_stock/tcn/tcn_train_structure_black_background.svg){: .dark}
_TCN train structure_

### Network levels: Train backbone & Consist network

TCN as a hierarchy of **two network levels**, a **train backbone** (TB) level **and** a **consist network** (CN) level. And consist networks are connected to the TB with train backbone nodes (TBN).

![TCN train structure](/assets/img/rolling_stock/tcn/tcn_network_example_white_background.svg){: .light}
![TCN train structure](/assets/img/rolling_stock/tcn/tcn_network_example_black_background.svg){: .dark}
_TCN train network_

#### Train backbone

It is a communication **network that links all parts of a train.**, connecting the control networks of each coach/car (train backbone nodes, TBN). It is the main “highway” for data exchange across the entire length of the train, **enabling coordinated operations between cars and centrally managed functions**.

To configure, it is necessary to:

1. List possible train compositions (“topologies”)
2. Define directions and orientation on vehicle, consist, closed train and train level
3. Do the train inauguration
4. Finally define the implemented TB services

Communication protocols used:  Wire Train Bus (WTB) or Ethernet Train Backbone (ETB).

#### Consist network

It is a communication **network that connects the electronic systems within a single vehicle/car/coach (the “consist”)**. It **allows onboard devices** and control units in the same car **to communicate** and share data.

Communication protocols used: Multifunction Vehicle Bus (MVB), CANopen or Ethernet Consist Network (ECN).

### Communication technology classes

These network technologies can be **classified in two technology classes**:

- **Bus** technology class. Wire Train Bus (WTB), Multifunction Vehicle Bus (MVB) and CANopen.
- **Switched** technology class. Ethernet Train Backbone (ETB) and Ethernet Consist Network (ECN).

## Train inauguration as part of train backbone

The train inauguration protocol is executed in all active TBN whenever a train is formed, vehicles are (dis)connected, or is powered up and determine:

- The sequence of all active TBN in a train (see an example video [TTDP, Train Topology Discovery Protocol](https://www.youtube.com/watch?v=dKdcR3d6IYg){:target="_blank"})
- Orientation of the consist, where a node is located in, with respect to the train orientation.

![TB TCN train directions](/assets/img/rolling_stock/tcn/tcn_directions_white_background.svg){: .light}
![TB TCN train directions](/assets/img/rolling_stock/tcn/tcn_directions_black_background.svg){: .dark}
_Train backbone TCN train directions_

>Depends on the technology of the train backbone: WTB or ETB.
{: .prompt-info }

## Communication patterns

![TCN communication patterns](/assets/img/rolling_stock/tcn/tcn_communication_patterns_white_background.svg){: .light}
![TCN communication patterns](/assets/img/rolling_stock/tcn/tcn_communication_patterns_black_background.svg){: .dark}
_TCN communication patterns_

## Communication data clases

TCN defines five main data classes. Detailed service parameter definitions are provided in application-specific communication profiles.

| Data class   | Description                                                           | Service parameters |
|--------------|-----------------------------------------------------------------------|--------------------|
| Supervisor   | Data for network operation tasks,<br>like setup or redundancy control |                    |
| Process      | Real-time control and monitoring data  | - Data rate ↓<br>- Cyclic transmission<br>- Latency ↓<br>- Jitter ↓<br>- Data integrity ↑<br>- Safety integrity ↑ |
| Message      | Control and monitoring messages        | - Data rate ↓ to -<br>- Latency -<br>- Data integrity ↑<br>- Safety integrity ↑ |
| Stream       | Video or voice data packets            | - Data rate ↑<br>- Latency ↓<br>- Jitter ↓<br>- Safety integrity ↓ |
| Best effort  | Bulk transfers or non-critical activities<br>that must not disrupt other data classes |    |

### Service paramentes

Each data class has communication service parameters that define its transmission characteristics.

| Service Parameter  | Description                                                 | Unit                   |
|--------------------|-------------------------------------------------------------|------------------------|
| Data packet size   | Amount of data transmitted in one packet                    | number of octets       |
| Data (packet) rate | Number of packets sent per second                           | bits/s, Kbit/s, Mbit/s |
| Cycle time         | Time between sending two packets (only for cyclically data) | seconds                |
| Latency            | Time for a packet to travel from source to sink             | seconds                |
| Jitter             | Variation in packet transmission time                       | seconds                |
| Data integrity     | Packet arrives without errors                               | bit error rate (BER)   |
| Safety Integrity   | Probability that errors (data corruption, sequence, timing<br>or authentication) will be detected | Probability of dangerous<br>undetected failures per hour (Pdu) |
