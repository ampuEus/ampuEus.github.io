---
title: What is CANopen's Electronic Data Sheet (EDS)
description: The scope of this article is to understand the basics of syntax and tools to work with Electronic Data Sheet (EDS).
# author:
# authors:
date: 2025-07-25 10:31:14 +0100
# last_modified_at: 2025-07-25 11:31:14 +0100
categories: [Field bus, Communication]
tags: [what is, can, canopen, eds]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: false
comments: false
image:
  path: /assets/img/field_bus_communication/can/canopen_eds.svg
  # lqip:
  # alt:
---

## Table of contents

- [Table of contents](#table-of-contents)
- [Definition](#definition)
- [File basic syntax](#file-basic-syntax)
  - [Standard sections](#standard-sections)
    - [File information](#file-information)
    - [General device information](#general-device-information)
    - [Mapping of dummy entries](#mapping-of-dummy-entries)
    - [Object dictionary lists](#object-dictionary-lists)
  - [Optional sections](#optional-sections)
    - [Comments](#comments)
    - [Tools](#tools)
- [References](#references)
- [Useful tools](#useful-tools)

## Definition

An **INI file** format (since 2007 XML is also valid), acting as the **'template' for the Object Dictionary** (OD) of a device and contains info on all device objects (PDOs, SDOs, specific objects defined in the device profiles...). The EDS file is a text file with the **extension “eds”**.

>An EDS is supplied by the vendor of a particular device. If a vendor provides no EDS for his CANopen devices a default EDS might be used.
{: .prompt-info }

EDS contain:

- Communication parameters as defined in *CiA301*.
- Application parameters as specified in CiA device and application profiles.
- Manufacturer-specific parameters as defined by the device manufacturer.

## File basic syntax

- The files are **ASCII-coded**, the /ISO646/ character set shall be used.
- The lines shall be **ended by a LF** character **or** by a **CR/LF combination**. The total **length of a line** shall **not exceed 255** characters.
- Section and keyname are **not case sensitive**.
- Section and keyname **order isn't relevant**.
- The EDS **contains several sections**; each consists of a group of related entries. The sections and the entries shall be listed in the following format:

```ini
; -------------------------
; --- This is a comment ---
; -------------------------

[section 1 name]
keyname_1=value
; Leading/trailing spaces in values are ignored
keyname_2= value

[section 2 name]
; Integer numbers shall be written as decimal numbers,
; hexadecimal numbers or octal numbers
; Decimal
keyname=10
; Hexadecimal numbers are preceded by 0x
keyname=0xa
keyname=0x0a
keyname=0xA
keyname=0x000A
; Octal numbers shall start with a leading 0
keyname=012

[section 3 name]
; String values are stored without quotes
keyname=hello
; Bitstrings shall be stored as a sequence of 0 and 1
keyname=0110100001101001

[section 4 name]
; For entries of one of the integer types a formula may be used (e.g. COB-ID)
; The $NODEID shall appear at the beginning of the expression.
; Otherwise the line is interpreted as without a formula.
keyname=$NODEID+number
```

### Standard sections

#### File information

Section name = [FileInfo]. The EDS contains information about itself. Useful for version control management.

| FileName          | File name (according to OS restrictions)                      |
|-------------------|---------------------------------------------------------------|
| FileVersion       | Actual file version (Unsigned8)                               |
| FileRevision      | Actual file revision (Unsigned8)                              |
| EDSVersion        | Version of the specification (3 characters) in the format “x.y”.<br>NOTE: If the entry is missing, this is equal to “3.0”. EDS files written according to this document shall use “4.0”  |
| Description       | File description (max 243 characters)                         |
| CreationTime      | File creation time (hh:mm(AM\|PM))                            |
| CreationDate      | Date of file creation (mm-dd-yyyy)                            |
| CreatedBy         | Name or description of the file creator (max. 245 characters) |
| ModificationTime  | Time of last modification (hh:mm(AM\|PM))                     |
| ModificationDate  | Date of the last file modification (mm-dd-yyyy)               |
| ModifiedBy        | Name or a description of the creator (max. 244 characters)    |

Example:

```ini
[FileInfo]
FileName=example name.eds
FileVersion=1
FileRevision=1
EDSVersion=4.0
Description=
CreationTime=20:31PM
CreationDate=26-06-2025
CreatedBy=my name
ModificationTime=21:43PM
ModificationDate=26-06-2025
ModifiedBy=my name
```

#### General device information

Section name = [DeviceInfo]. Contain device specific information.

| VendorName               | Vendor name (max. 244 characters)                                                   |
|--------------------------|-------------------------------------------------------------------------------------|
| VendorNumber             | Unique vendor ID according to identity object sub-index 01h (Unsigned32). [Oficial CANopen ventor-ID list](https://www.can-cia.org/services/canopen-vendor-id/){:target="_blank"} |
| ProductName              | Product name (max. 243 characters)                                                  |
| ProductNumber            | Product code according to identity object sub-index 02h (Unsigned32)                |
| RevisionNumber           | Product revision number according to identity object sub-index 03h (Unsigned32)     |
| OrderCode                | Order code for this product (max. 245 characters)                                   |
| BaudRate_10              | Indicate the supported baud rates (0 = not supported, 1=supported)                  |
| BaudRate_20              |                                                                                     |
| BaudRate_500             |                                                                                     |
| BaudRate_125             |                                                                                     |
| BaudRate_250             |                                                                                     |
| BaudRate_500             |                                                                                     |
| BaudRate_800             |                                                                                     |
| BaudRate_1000            |                                                                                     |
| SimpleBootUpMaster       | Indicate the simple boot-up master functionality (0 = not supported, 1 = supported) |
| SimpleBootUpSlave        | Indicate the simple boot-up slave functionality (0 = not supported, 1 = supported)  |
| Granularity              | Granularity allowed for the mapping on this device. (Unsigned8; 0 = mapping not modifiable, 1-64 = granularity) |
| DynamicChannelsSupported | According to *CiA302*, indicate the facility of dynamic variable generation. If the value is unequal to 0, the additional section `DynamicChannels` exists.     |
| GroupMessaging           | According to *CiA301 Annex A*, indicate the facility of multiplexed PDOs. (0 = not supported, 1 = supported).                                                   |
| NrOfRXPDO                | Number of supported receive PDOs (Unsigned16)                                       |
| NrOfTXPDO                | Number of supported transmit PDOs (Unsigned16)                                      |
| LSS_Supported            | Indicate if LSS functionality is supported (0 = not supported, 1 = supported)       |

>For compatibility reasons, the entries `ProductVersion`, `ProductRevision`, `LMT_ManufacturerName`, `LMT_ProductName`, `ExtendedBootUpMaster` and `ExtendedBootUpSlave` are reserved.
{: .prompt-info }

Example:

```ini
[DeviceInfo]
VendorName=company name
VendorNumber=0x00000000
ProductName=Example turbo 3000
ProductNumber=0x00000000
RevisionNumber=0x00000000
BaudRate_50=1
BaudRate_250=1
BaudRate_1000=1
SimpleBootUpMaster=0
SimpleBootUpSlave=1
Granularity=8
DynamicChannelsSupported=0
GroupMessaging=0
NrOfRXPDO=1
NrOfTXPDO=3
LSS_Supported=0
; This is a "Specific flag" to define a specific behaviour for tools how to treat an object.
CompactPDO=0
```

#### Mapping of dummy entries

Section name = [DummyUsage]. Contain device specific information. Sometimes it is required to leave gaps in the mapping of a device.

Format = `Dummy<data type index (without 0x-prefix)>={0|1}`

Example:

```ini
[DummyUsage]
Dummy0001=0
Dummy0002=1
Dummy0003=1
Dummy0004=1
Dummy0005=1
Dummy0006=1
Dummy0007=1
```

#### Object dictionary lists

This sections configure the device:

- Which objects of the object dictionary are supported
- Limit values for parameters
- Default values
- Data types

Object descriptions:

- `[MandatoryObjects]` Contain the mandatory objects (1000h, 1001h and 1018h)
- `[OptionalObjects]` Contain all other objects of the area (1000h-1FFFh and 6000H-FFFFh).
- `[ManufacturerObjects]` Contain all manufacturer specific objects (2000h-5FFFh).

<details>
<summary>See Object Dictionary overview (0000h - FFFFh).</summary>
<table><thead>
  <tr>
    <th>Index</th>
    <th>Object</th>
  </tr></thead>
<tbody>
  <tr>
    <td>0000h</td>
    <td>not used</td>
  </tr>
  <tr>
    <td>0001h – 001Fh</td>
    <td>Static data types (standard data types, e.g. Boolean, Integer16)</td>
  </tr>
  <tr>
    <td>0020h – 003Fh</td>
    <td>Complex data types (predefined structures composed of standard data types, e.g. PDOCommPar, SDOParameter)</td>
  </tr>
  <tr>
    <td>0040h – 005Fh</td>
    <td>Manufacturer-specific complex data types</td>
  </tr>
  <tr>
    <td>0060h – 025Fh</td>
    <td>Device profile specific data types</td>
  </tr>
  <tr>
    <td>0260h – 0FFFh</td>
    <td>reserved</td>
  </tr>
  <tr>
    <td>1000h – 1FFFh</td>
    <td>Communication profile area (e.g. Device Type, Error Register, Number of PDOs supported)</td>
  </tr>
  <tr>
    <td>2000h – 5FFFh</td>
    <td>Manufacturer-specific profile area</td>
  </tr>
  <tr>
    <td>6000h – 9FFFh</td>
    <td>Standardised Device Profile Area (e.g. "DSP-401 Device Profile for I/0 Modules" [3]: Read State 8 Input Lines, etc.)</td>
  </tr>
  <tr>
    <td>A000h – BFFFh</td>
    <td>Standardized network variable area</td>
  </tr>
  <tr>
    <td>C000h – FFFFh</td>
    <td>reserved</td>
  </tr>
</tbody></table>
>Don't be confused by all the 'data types' located in the OD at indices below 0FFF; they're there mainly or definition purposes only. The relevant range of a node's OD lies between 1000 and 9FFF.
</details>

<details>
<summary>See Communication profile area (1000h - 1F89h).</summary>
<table><thead>
  <tr>
    <th>Index range </th>
    <th>Description</th>
  </tr></thead>
<tbody>
  <tr>
    <td>1000h - 1029h </td>
    <td>General communication objects</td>
  </tr>
  <tr>
    <td>1200h - 12FFh </td>
    <td>SDO parameter objects</td>
  </tr>
  <tr>
    <td>1300h - 13FFh </td>
    <td>CANopen safety objects</td>
  </tr>
  <tr>
    <td>1400h - 1BFFh </td>
    <td>PDO parameter objects</td>
  </tr>
  <tr>
    <td>1F00h - 1F11h </td>
    <td>SDO manager objects</td>
  </tr>
  <tr>
    <td>1F20h - 1F27h </td>
    <td>Configuration manager objects</td>
  </tr>
  <tr>
    <td>1F50h - 1F54h </td>
    <td>Program control objects</td>
  </tr>
  <tr>
    <td>1F80h - 1F89h </td>
    <td>NMT master objects</td>
  </tr>
</tbody>
</table>
</details>

<details>
<summary>See General communication objects (1000h - 1029h).</summary>
<table><thead>
  <tr>
    <th>Index</th>
    <th>Object</th>
    <th>Name</th>
  </tr></thead>
<tbody>
  <tr>
    <td>1000h</td>
    <td>VAR</td>
    <td>Device type</td>
 </tr>
  <tr>
    <td>1001h</td>
    <td>VAR</td>
    <td>Error register</td>
 </tr>
  <tr>
    <td>1002h</td>
    <td>VAR</td>
    <td>Manufacturer status register</td>
 </tr>
  <tr>
    <td>1003h</td>
    <td>ARRAY</td>
    <td>Pre-defined error field</td>
 </tr>
  <tr>
    <td>1005h</td>
    <td>VAR</td>
    <td>COB-ID Sync message</td>
 </tr>
  <tr>
    <td>1006h</td>
    <td>VAR</td>
    <td>Communication cycle period</td>
 </tr>
  <tr>
    <td>1007h</td>
    <td>VAR</td>
    <td>Synchronous window length</td>
 </tr>
  <tr>
    <td>1008h</td>
    <td>VAR</td>
    <td>Manufacturer device name</td>
 </tr>
  <tr>
    <td>1009h</td>
    <td>VAR</td>
    <td>Manufacturer hardware version</td>
 </tr>
  <tr>
    <td>100Ah</td>
    <td>VAR</td>
    <td>Manufacturer software version</td>
 </tr>
  <tr>
    <td>100Ch</td>
    <td>VAR</td>
    <td>Guard time</td>
 </tr>
  <tr>
    <td>100Dh</td>
    <td>VAR</td>
    <td>Life time factor</td>
 </tr>
  <tr>
    <td>1010h</td>
    <td>VAR</td>
    <td>Store parameters</td>
  </tr>
  <tr>
    <td>1011h</td>
    <td>VAR</td>
    <td>Restore default parameters</td>
  </tr>
  <tr>
    <td>1012h</td>
    <td>VAR</td>
    <td>COB-ID time stamp</td>
 </tr>
  <tr>
    <td>1013h</td>
    <td>VAR</td>
    <td>High resolution time stamp</td>
 </tr>
  <tr>
    <td>1014h</td>
    <td>VAR</td>
    <td>COB-ID emergency</td>
 </tr>
  <tr>
    <td>1015h</td>
    <td>VAR</td>
    <td>Inhibit time emergency</td>
 </tr>
  <tr>
    <td>1016h</td>
    <td>ARRAY</td>
    <td>Consumer heartbeat time</td>
 </tr>
  <tr>
    <td>1017h</td>
    <td>VAR</td>
    <td>Producer heartbeat time</td>
 </tr>
  <tr>
    <td>1018h</td>
    <td>RECORD</td>
    <td>Identity object</td>
 </tr>
  <tr>
    <td>1019h</td>
    <td>VAR</td>
    <td>Sync. counter overflow value</td>
 </tr>
  <tr>
    <td>1020h</td>
    <td>ARRAY</td>
    <td>Verify configuration</td>
 </tr>
  <tr>
    <td>1021h</td>
    <td>VAR</td>
    <td>Store EDS</td>
 </tr>
  <tr>
    <td>1022h</td>
    <td>VAR</td>
    <td>Storage format</td>
 </tr>
  <tr>
    <td>1023h</td>
    <td>RECORD</td>
    <td>OS command</td>
 </tr>
  <tr>
    <td>1024h</td>
    <td>VAR</td>
    <td>OS command mode</td>
 </tr>
  <tr>
    <td>1025h</td>
    <td>RECORD</td>
    <td>OS debugger interface</td>
 </tr>
  <tr>
    <td>1026h</td>
    <td>ARRAY</td>
    <td>OS prompt</td>
 </tr>
  <tr>
    <td>1027h</td>
    <td>ARRAY</td>
    <td>Module list</td>
 </tr>
  <tr>
    <td>1028h</td>
    <td>ARRAY</td>
    <td>Emergency consumer</td>
  </tr>
  <tr>
    <td>1029h</td>
    <td>ARRAY</td>
    <td>Error behavior</td>
  </tr>
</tbody></table>
</details>

>Each of these sections shall contain a list of the supported objects which contains entries for the supported objects. `SupportedObjects` = Number of entries in the section (Unsigned16).
{: .prompt-info }

<details>
<summary>See an example.</summary>
<pre>
[MandatoryObjects]
SupportedObjects=3
1=0x1000
2=0x1001
3=0x1018

[...]

[OptionalObjects]
SupportedObjects=17
1=0x1008
2=0x1009
3=0x100A
4=0x100C
5=0x100D
6=0x1013
7=0x1016
8=0x1017
9=0x1200
10=0x1400
11=0x1600
12=0x1800
13=0x1801
14=0x1802
15=0x1A00
16=0x1A01
17=0x1A02

[...]

[ManufacturerObjects]
SupportedObjects=20
1=0x2000
2=0x2001
3=0x2002
4=0x2003
5=0x2004
6=0x2005
7=0x2006
8=0x2007
9=0x2008
10=0x2009
11=0x200A
12=0x200B
13=0x200C
14=0x200D
15=0x200E
16=0x200F
17=0x2010
18=0x2011
19=0x2012
20=0x2013
</pre>
</details>

Section's keynames:

| SubNumber     | Number of sub-indexes available at this index (Unsigned8) |
|---------------|-----------------------------------------------------------|
| ParameterName | Parameter name (up to 241 characters)                     |
| ObjectType    | Object code                                               |
| DataType      | Index of the data type of the object in the OD            |
| LowLimit      | [Only if applicable] Lowest limit of the object value     |
| HighLimit     | [Only if applicable] Upper limit of the object value      |
| AccessType    |                                                           |
| DefaultValue  | Default value for this object                             |
| PDOMapping    | If it is possible to map this object into a PDO (Boolean, 0 = not mappable, 1 = mappable) |
| ObjFlags      | [Optional] Assignment of special behavior                 |

<details>
<summary>See an overview of the obligation of keywords.</summary>

Table legend:

- m = Mandatory
- o = Optional. If the entry is missing "( )" says default value
- n = Not supported

<table><thead>
  <tr>
    <th></th>
    <th>DEFTYPE<br>VAR</th>
    <th>DEFSTRUCT<br>ARRAY<br>RECORD</th>
    <th>DEFSTRUCT<br>ARRAY<br>RECORD</th>
    <th>DOMAIN</th>
  </tr></thead>
<tbody>
  <tr>
    <td>ParameterName</td>
    <td>m</td>
    <td>m</td>
    <td>m</td>
    <td>m</td>
  </tr>
  <tr>
    <td>ObjectType</td>
    <td>o (VAR)</td>
    <td>m</td>
    <td>m</td>
    <td>m</td>
  </tr>
  <tr>
    <td>DataType</td>
    <td>m</td>
    <td>n</td>
    <td>m</td>
    <td>o (DOMAIN)</td>
  </tr>
  <tr>
    <td>AccessType</td>
    <td>m</td>
    <td>n</td>
    <td>m</td>
    <td>o (rw)</td>
  </tr>
  <tr>
    <td>DefaultValue</td>
    <td>o ()</td>
    <td>n</td>
    <td>o ()</td>
    <td>o ()</td>
  </tr>
  <tr>
    <td>PDOMapping</td>
    <td>o (0)</td>
    <td>n</td>
    <td>o (0)</td>
    <td>n</td>
  </tr>
  <tr>
    <td>SubNumber</td>
    <td>n</td>
    <td>m</td>
    <td>n</td>
    <td>n</td>
  </tr>
  <tr>
    <td>LowLimit</td>
    <td>o ()</td>
    <td>n</td>
    <td>o ()</td>
    <td>n</td>
  </tr>
  <tr>
    <td>HighLimit</td>
    <td>o ()</td>
    <td>n</td>
    <td>o ()</td>
    <td>n</td>
  </tr>
  <tr>
    <td>ObjFlags</td>
    <td>o (0)</td>
    <td>o (0)</td>
    <td>o (0)</td>
    <td>o (0)</td>
  </tr>
  <tr>
    <td>CompactSubObj</td>
    <td>n</td>
    <td>n</td>
    <td>m</td>
    <td>n</td>
  </tr>
</tbody></table>
</details>

<details>
<summary>See an example of an EDS's one RPDO definition</summary>
<pre>

[...]

[1402]
ParameterName=Receive PDO Communication Parameter 2
ObjectType=0x9
SubNumber=4

[1402sub0]
ParameterName=Number of entries
ObjectType=0x7
DataType=0x0005
AccessType=ro
DefaultValue=5
PDOMapping=0
LowLimit=0x02
HighLimit=0x05

[1402sub1]
ParameterName=COB ID
ObjectType=0x7
DataType=0x0007
AccessType=rw
DefaultValue=0x400+$NODEID
PDOMapping=0
LowLimit=0x00000001
HighLimit=0xFFFFFFFF

[1402sub2]
ParameterName=Transmission Type
ObjectType=0x7
DataType=0x0005
AccessType=rw
DefaultValue=1
PDOMapping=0

[1402sub5]
ParameterName=Event Timer
ObjectType=0x7
DataType=0x0006
AccessType=rw
DefaultValue=0
PDOMapping=0

[...]

[1602]
ParameterName=Receive PDO Mapping Parameter 2
ObjectType=0x9
SubNumber=5

[1602sub0]
ParameterName=Number of entries
ObjectType=0x7
DataType=0x0005
AccessType=rw
DefaultValue=4
PDOMapping=0
LowLimit=0
HighLimit=8

[1602sub1]
ParameterName=PDO Mapping Entry
ObjectType=0x7
DataType=0x0007
AccessType=rw
DefaultValue=0x20000910
PDOMapping=0

[1602sub2]
ParameterName=PDO Mapping Entry
ObjectType=0x7
DataType=0x0007
AccessType=rw
DefaultValue=0x20000a10
PDOMapping=0

[1602sub3]
ParameterName=PDO Mapping Entry
ObjectType=0x7
DataType=0x0007
AccessType=rw
DefaultValue=0x20010110
PDOMapping=0

[1602sub4]
ParameterName=PDO Mapping Entry
ObjectType=0x7
DataType=0x0007
AccessType=rw
DefaultValue=0x20010210
PDOMapping=0

[...]

[2000]
ParameterName=Reception Element 2
ObjectType=0x9
SubNumber=11

[2000sub0]
ParameterName=NrOfObjects
ObjectType=0x7
DataType=0x0005
AccessType=rww
DefaultValue=10
PDOMapping=0

[...]

[2000sub9]
ParameterName=i_sp_lim_pow
ObjectType=0x7
DataType=0x0006
AccessType=rww
PDOMapping=1

[2000subA]
ParameterName=i_sp_lim_pow_ef
ObjectType=0x7
DataType=0x0006
AccessType=rww
PDOMapping=1

[2001]
ParameterName=Reception Element 3
ObjectType=0x9
SubNumber=11

[2001sub0]
ParameterName=NrOfObjects
ObjectType=0x7
DataType=0x0005
AccessType=rww
DefaultValue=10
PDOMapping=0

[2001sub1]
ParameterName=rcw_gen_10
ObjectType=0x7
DataType=0x0006
AccessType=rww
PDOMapping=1

[2001sub2]
ParameterName=rcw_gen_11
ObjectType=0x7
DataType=0x0006
AccessType=rww
PDOMapping=1

[...]
</pre>
</details>

### Optional sections

#### Comments

Section name = [Comments]. To add comments to the EDS. Example:

```ini
[Comments]
Lines=3
Line1=|-------------|
Line2=| Hello World |
Line3=|-------------|
```

#### Tools

Section `name = [Tools]`. Based on *CiA 405*, describe some aspects of the usage of the EDS by software packages.

## References

- CiA standard 306: CANopen electronic data sheet (EDS)
- [CiA 306: Electronic Device Description (EDD)](https://www.can-cia.org/can-knowledge/cia-306-series-electronic-device-description-edd){:target="_blank"}
- [CANopen EDS File Explained - A Simple Intro](https://www.csselectronics.com/pages/canopen-eds-file-electronic-data-sheet){:target="_blank"}
- [EDS & DCF files](https://support.dis-sensors.nl/kb/faq.php?id=13){:target="_blank"}
- <https://en.wikipedia.org/wiki/CANopen>{:target="_blank"}

## Useful tools

- [CANeds - Editor for creating and checking EDS files](https://www.vector.com/int/en/download/caneds/){:target="_blank"}
- [CANopen Object Dictionary Editor](https://github.com/CANopenNode/CANopenEditor){:target="_blank"}

