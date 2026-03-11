---
title: How to set up touchscreen on Linux (on X-server or Wayland)
description: Step-by-step guide to detect, map, and calibrate touchscreens on Linux , covering xinput, xrandr, xinput_calibrator, and persistent Xorg configuration.
# author:
# authors:
date: 2026-03-11 20:06:47 +0100
# last_modified_at: 2026-03-11 20:06:47 +0100
categories: [Linux]
tags: [how to, xorg-server, touchscreen]  # TAG names should always be lowercase
toc: true  # (Table of Contents) The default value is on _config.yml
pin: false
math: false
mermaid: true
comments: false
image:
  path: /assets/img/others/touchscreen_laptop-ia.png
  # lqip:
  alt: Image generated with IA
---

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Step 0: Check if device is supported by the kernel](#step-0-check-if-device-is-supported-by-the-kernel)
- [\[If kernel do not detect\] Get X11 drivers](#if-kernel-do-not-detect-get-x11-drivers)
  - [\[Extra\] How to see the driver you are using](#extra-how-to-see-the-driver-you-are-using)
    - [Method 1: `xinput list-props`](#method-1-xinput-list-props)
    - [Method 2: System logs](#method-2-system-logs)
- [\[Optional\] Touchscreen in a multi-screen setup: Adjust the *Coordinate Transformation Matrix*](#optional-touchscreen-in-a-multi-screen-setup-adjust-the-coordinate-transformation-matrix)
- [Calibrate: Adjust the *Axis Calibration Matrix*](#calibrate-adjust-the-axis-calibration-matrix)
  - [Permanent calibration: `xorg.conf.d`](#permanent-calibration-xorgconfd)
- [\[Optional\] Gestures and Two-fingers scrolling](#optional-gestures-and-two-fingers-scrolling)
- [References](#references)

## Step 0: Check if device is supported by the kernel

`/proc/bus/input/devices` file lists all input devices the Linux kernel currently knows about.

```shell
cat /proc/bus/input/devices
```

```shell
[...]

I: Bus=0003 Vendor=1fd2 Product=8105 Version=0111
N: Name="Melfas LGDisplay Incell Touch" # Name of the device.
P: Phys=usb-0000:00:14.0-4.3.2.1/input0
S: Sysfs=/devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.3/1-4.3.2/1-4.3.2.1/1-4.3.2.1:1.0/0003:1FD2:8105.0002/input/input16
U: Uniq=
H: Handlers=mouse0 event15 # Assigned handlers
B: PROP=2
B: EV=1b
B: KEY=400 0 0 0 0 0
B: ABS=260800000000003
B: MSC=20

[...]
```

Verify it’s the right device `/dev/input/eventX` and touching the screen. If you see characters streaming, that’s the one to use with `xinput`.

```shell
sudo cat /dev/input/event15
```

Output touching the screen:

![cat /dev/input/event15 output touching the screen](/assets/img/linux/touchscreen/eventX_output.png)

## [If kernel do not detect] Get X11 drivers

Depending on your touchscreen device choose an appropriate driver. You can use proprietary (if it's available) or open source driver. The most common open-source drivers are:

- [evdev](https://www.kernel.org/doc/html/latest/input/input.html#evdev): Generic input event interface in the [Linux kernel](https://github.com/torvalds/linux/blob/master/drivers/input/evdev.c) and FreeBSD.
- [libinput](https://freedesktop.org/wiki/Software/libinput/): For [Wayland/Weston](https://wayland.freedesktop.org/) compositor.

>libinput/libevdev sit between the kernel and the user-level input handler, translating kernel events into a device API used by X or Wayland.
>
>- kernel → libevdev → xf86-input-evdev → X server → X client
>
>For Wayland/Weston compositor, the stack would look like this:
>
>- kernel → libevdev → libinput → Wayland compositor → Wayland client
>
>Since xorg-server 1.16, X supports `libinput` via the `xf86-input-libinput` driver:
>
>- kernel → libevdev → libinput → xf86-input-libinput → X server → X client
{: .prompt-info }

### [Extra] How to see the driver you are using

#### Method 1: `xinput list-props`

First get device name (in my case *Melfas LGDisplay Incell Touch*):

```shell
xinput
```

Output:

```shell
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ Melfas LGDisplay Incell Touch             id=10   [slave  pointer  (2)]
⎜   ↳ Logitech Wireless Mouse PID:4022          id=11   [slave  pointer  (2)]
⎜   ↳ Logitech Wireless Keyboard PID:4023       id=12   [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Power Button                              id=8    [slave  keyboard (3)]
    ↳ Sleep Button                              id=9    [slave  keyboard (3)]
    ↳ Dell WMI hotkeys                          id=13   [slave  keyboard (3)]
    ↳ Dell AIO WMI hotkeys                      id=14   [slave  keyboard (3)]
    ↳ Logitech Wireless Keyboard PID:4023       id=15   [slave  keyboard (3)]
```

And then get more detailed information:

```shell
xinput list-props "Melfas LGDisplay Incell Touch"
```

On the output you can see how the device use `libinput` driver:

```shell
Device 'Melfas LGDisplay Incell Touch':
        Device Enabled (179):   1
        Coordinate Transformation Matrix (181): 0.500000, 0.000000, 0.500000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Calibration Matrix (318):      1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Calibration Matrix Default (319):      1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        libinput Send Events Modes Available (301):     1, 0
        libinput Send Events Mode Enabled (302):        0, 0
        libinput Send Events Mode Enabled Default (303):        0, 0
        Device Node (304):      "/dev/input/event15"
        Device Product ID (305):        8146, 33029
```

#### Method 2: System logs

Search for device name on system general logs (in my case *Melfas LGDisplay Incell Touch*):

```shell
sudo journalctl | grep "'Melfas LGDisplay Incell Touch'"
```

>Note that I use `'` simple quotes on the `grep` command.
{: .prompt-info }

And on the output find a line similar to this one, that as you can see says that the input driver is `libinput`:

```shell
(II) Using input driver 'libinput' for 'Melfas LGDisplay Incell Touch'
```

## [Optional] Touchscreen in a multi-screen setup: Adjust the *Coordinate Transformation Matrix*

You need to map the touchscreen to your actual touchscreen display. This is made by `xinput`'s `map-to-output` option.

```shell
# Generic command
xinput map-to-output <touch-input device (name or id)> <output name>
```

To get the *touch-input device name* execute `xinput`, and see the output (In this case is `Melfas LGDisplay Incell Touch`):

```shell
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ Melfas LGDisplay Incell Touch             id=10   [slave  pointer  (2)]
⎜   ↳ Logitech Wireless Mouse PID:4022          id=11   [slave  pointer  (2)]
⎜   ↳ Logitech Wireless Keyboard PID:4023       id=12   [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Power Button                              id=8    [slave  keyboard (3)]
    ↳ Sleep Button                              id=9    [slave  keyboard (3)]
    ↳ Dell WMI hotkeys                          id=13   [slave  keyboard (3)]
    ↳ Dell AIO WMI hotkeys                      id=14   [slave  keyboard (3)]
    ↳ Logitech Wireless Keyboard PID:4023       id=15   [slave  keyboard (3)]
```

Now to know device *output interface name* execute `xrandr`, and see the output ():

```shell
Screen 0: minimum 320 x 200, current 3840 x 1080, maximum 16384 x 16384
HDMI-1 connected 1920x1080+1920+0 (normal left inverted right x axis y axis) 527mm x 296mm
   1920x1080     60.00*+  50.00    59.94
   1920x1080i    60.00    50.00    59.94
   1600x900      60.00
   1280x1024     75.02    60.02

[...]

DP-2-1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 527mm x 296mm
   1920x1080     60.00*+  50.00    59.94
   1600x1200     60.00
   1600x900      60.00
   1280x1024     75.02    60.02
   1152x864      75.00

[...]
```

In this case is `HDMI-1`, I know it because the touchscreen isn't the `primary` monitor.

>If unsure which touchscreen corresponds to which monitor, temporarily map it to an output, touch the screen, and verify the pointer moves only on that monitor.
{: .prompt-tip }

So the final command to map the touch input to output monitor is:

```shell
xinput map-to-output "Melfas LGDisplay Incell Touch" HDMI-1
```

## Calibrate: Adjust the *Axis Calibration Matrix*

The tool to calibrate a touchscreen is called [xinput_calibrator](https://www.freedesktop.org/wiki/Software/xinput_calibrator/).

**`xinput_calibrator` works only for single-screen setups**. It sets the device's *"Axis Calibration Matrix"* and doesn't account for a *"Coordinate Transformation Matrix"* used when mapping to a specific output. It also always opens stretched to the full available output area.

![Calibration tool with all displays on](/assets/img/linux/touchscreen/calibrate_with_all_displays_on.jpg)
_Calibration tool with all displays on_
![Calibration tool only with touchscreen displays on](/assets/img/linux/touchscreen/calibrate_with_only_selected_display.jpg)
_Calibration tool only with touchscreen displays on_

1. Turn off all the monitor except the one that you want to calibrate → `xrandr --output <non-touch-output> --off`
2. Reset *"Coordinate Transformation Matrix"* if you map it before → `xinput map-to-output <touch input device> <touch-output>`
3. Calibrate with → `xinput_calibrator`. You should now have well-calibrated touch on the single screen.
4. Re-enable the other monitors → `xrandr --output <non-touch-output> --mode <resolution>`. If you need position options use `--right-of`, `--left-of`, `--above`, `--below` place the monitor relative to another.
5. Map the touchscreen again to his monitor → `xinput map-to-output <touch input device> <touch-output>`

### Permanent calibration: `xorg.conf.d`

To make the new values permanent you need to create a [configuration files for Xorg X server](https://www.x.org/releases/X11R7.6/doc/man/man5/xorg.conf.5.xhtml) (normally on `/usr/share/X11/xorg.conf.d/` on Debian based OS), named with a sufficiently low priority (`90-calibration.conf`). The file's data will be:

```shell
Section "InputClass"
        Identifier                      "calibration"
        MatchProduct                    "<DEVICE_NAME_FROM_XINPUT_LIST>"
        Option  "TransformationMatrix"  "<VALUES_FROM(Coordinate Transformation Matrix)>"
        Option  "Calibration"           "<VALUES_FROM(Evdev Axis Calibration)>"
        Option  "SwapAxes"              "<VALUE_FROM(Evdev Axes Swap)>"
        Option  "InvertX"               "<X_VALUE_FROM(Evdev Axis Inversion)>"
        Option  "InvertY"               "<Y_VALUE_FROM(Evdev Axis Inversion)>"
EndSection
```

## [Optional] Gestures and Two-fingers scrolling

You can try installing [Touchegg](https://github.com/JoseExposito/touchegg), an app that runs in the background and transform the gestures you make on your touchpad or touchscreen into visible actions in your desktop.

## References

- <https://wiki.archlinux.org/title/Touchscreen>
- <https://en.wikipedia.org/wiki/Evdev>
- <https://askubuntu.com/questions/253395/touchscreen-calibration-with-dual-monitors-nvidia-and-xinput>
