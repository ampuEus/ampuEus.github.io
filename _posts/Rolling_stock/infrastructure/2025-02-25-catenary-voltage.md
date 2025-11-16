---
title: Supply voltages of railway systems
description: Overview of all the catenary supply voltages worldwide.
# author:
# authors:
date: 2025-02-25 20:00:27 +0100
# last_modified_at: 2025-02-25 20:00:34 +0100
categories: [Rolling stock]
tags: [railway system, supply voltage]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/rolling_stock/catenary/world_railway_electrification_with_legend.webp
  # lqip:
  alt:
---

Voltages and frequencies are **defined by** two standards: **EN 50163** and **IEC 60850**.

<table><thead>
  <tr>
    <th style="text-align: center;">Electrification System</th>
    <th style="text-align: center;">Lowest<br>Non-permanent<br>Voltage [V]</th>
    <th style="text-align: center;">Lowest<br>Permanent<br>Voltage [V]</th>
    <th style="text-align: center;">Nominal<br>Voltage [V]</th>
    <th style="text-align: center;">Highest<br>Permanent<br>Voltage [V]</th>
    <th style="text-align: center;">Highest<br>Non-permanent<br>Voltage [V]</th>
  </tr></thead>
<tbody>
  <tr>
    <td rowspan="4">DC<br>(mean values)</td>
    <td>400</td>
    <td>400</td>
    <td>600</td>
    <td>720</td>
    <td>800</td>
  </tr>
  <tr>
    <td>500</td>
    <td>500</td>
    <td>750</td>
    <td>900</td>
    <td>1000</td>
  </tr>
  <tr>
    <td>1000</td>
    <td>1000</td>
    <td>1500</td>
    <td>1800</td>
    <td>1950</td>
  </tr>
  <tr>
    <td>2000</td>
    <td>2000</td>
    <td>3000</td>
    <td>3600</td>
    <td>3900</td>
  </tr>
  <tr>
    <td rowspan="2">AC<br>(r.m.s. values)</td>
    <td>11000</td>
    <td>12000</td>
    <td>15000</td>
    <td>17250</td>
    <td>18000</td>
  </tr>
  <tr>
    <td>17500</td>
    <td>19000</td>
    <td>25000</td>
    <td>27500</td>
    <td>29000</td>
  </tr>
</tbody></table>

The frequency of the 50 Hz electric traction system is imposed by the three phase grid. Therefore, the
values stated by EN 50160 are applicable. The frequency of the 16,7 Hz electric traction system (except
for synchronous- synchronous converters) is not imposed by the three phase grid.

<table><thead>
  <tr>
    <th></th>
    <th colspan="2" style="text-align: center;">Systems synchronous connection<br>+<br>Interconnected system</th>
    <th colspan="2" style="text-align: center;">Systems no synchronous connection<br>+<br>Interconnected system</th>
    <th colspan="2" style="text-align: center;">Systems connected to the railway<br>+<br>Interconnected grid</th>
  </tr></thead>
<tbody>
  <tr>
    <td rowspan="2">50 Hz</td>
    <td>50 Hz ± 1%</td>
    <td>for 99,5% of a year</td>
    <td>50 Hz ± 2%</td>
    <td>for 95% of a week</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>50 Hz + 4% / - 6%</td>
    <td>for 99,5% of a year</td>
    <td>50 Hz ± 15%</td>
    <td>for 100% of the time</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td rowspan="2">16,7 Hz</td>
    <td>16,7 Hz ± 1%</td>
    <td>for 99,5% of a year</td>
    <td>16,7 Hz ± 2%</td>
    <td>for 95% of a week</td>
    <td>16,7 Hz + 2% / - 3%</td>
    <td>for 100% of the time</td>
  </tr>
  <tr>
    <td>16,7 Hz ± 6%</td>
    <td>for 100% of the time</td>
    <td>16,7 Hz ± 15%</td>
    <td>for 100 % of the time</td>
    <td></td>
    <td></td>
  </tr>
</tbody></table>

## AC or DC traction

**It doesn’t really matter whether you have AC or DC motors, nowadays either can work with an AC or DC supply.** You just need to put the right sort of control system between the supply and the motor and it will work. However, the choice of AC or DC power transmission system along the line is important. Generally, it’s a question of what sort of railway you have. It can be summarized simply as **AC for long distance** and **DC for short distance**.

> AC systems always use overhead wires, DC can use either an overhead wire or a third rail. And the **return circuit is via the running rails back to the substation**. The running rails are at earth potential and are connected to the substation.
{: .prompt-tip }

It is **easier to boost the voltage of AC** than that of DC, so it is easier to send more power over transmission lines with AC.

DC, on the other hand was the preferred option for shorter lines, urban systems and tramways. Apart from only requiring a **simple control system for the motors**, the **smaller size of urban operations** meant that **trains** were usually **lighter and needed less power**. But it needed a **heavier transmission medium** to carry the power and it lost a fair amount of voltage as the distance between supply connections increased.

> This was overcome by placing substations at close intervals – every three or four kilometers at first, nowadays two or three on a 750 V system – compared with every 20 kilometers or so for a 25 kV AC line.
{: .prompt-info }

## Voltages distribution overview

This are some examples of nominal supply voltages and installed power of different types of rolling stock:

![Supply voltages and installed power of different types of rolling stock](/assets/img/rolling_stock/catenary/supply_voltages_installed_power_on_different_type_rolling_stock.webp)

And an overview of Europe railway electrification map with different supply voltages:

![Europe railway supply voltage map](/assets/img/rolling_stock/catenary/europe_supply_voltage.webp)

## References

- [openrailwaymap](https://openrailwaymap.org/){:target="_blank"}
- <http://www.railway-technical.com/infrastructure/electric-traction-power.html>{:target="_blank"}
- EN 50163 (2007), EN 50163: Railway applications. Supply voltages of traction systems, IET
- **8.1.2.1 Performances of the traction system.** In Rolling Stock in the Railway System (2020th ed., Vol. 3, pp. 22–23). essay, Trackomedia.
