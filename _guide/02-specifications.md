---
title: Specifications
order: 2
summary: Processor, memory, screen, radios, battery
permalink: /guide/specifications/
---
Figures of the original Nokia specification (model RX-51). They matter when you choose what to run on it.

| | |
|---|---|
| **Processor** | TI OMAP3430, ARM Cortex-A8, 600 MHz (armel, ARMv7; no hard-float userland) |
| **Graphics** | PowerVR SGX530 (OpenGL ES 2.0) |
| **Memory** | 256 MB RAM, plus swap; 1 GB of virtual memory in total |
| **Storage** | 32 GB flash in three parts: the root file system (about 230 MB, it fills up quickly), `/home` with `/opt` (2 GB, ext3) and `MyDocs` (about 27 GB, FAT: files only, programs cannot run from it) |
| **Card slot** | microSD (hot-swappable behind the back cover) |
| **Display** | 3.5 inch, 800 x 480, resistive touch, 16 million colours |
| **Keyboard** | slide-out QWERTY, landscape (the phone is used sideways) |
| **Camera** | 5 Mpx, Carl Zeiss optics, autofocus, dual LED flash; video 848 x 480 at 25 fps; no front camera |
| **Mobile network** | GSM 850/900/1800/1900, WCDMA (3G) 900/1700/2100, HSDPA 10.2 Mbps, HSUPA 2 Mbps. No 4G. |
| **Wi-Fi** | 802.11 b/g (no 5 GHz, WPA2-PSK at most for personal networks) |
| **Bluetooth** | 2.1 with EDR |
| **Location** | GPS with A-GPS |
| **Sensors** | accelerometer, proximity, ambient light |
| **Connectors** | micro-USB (charging, data, USB host with an OTG cable), 3.5 mm 4-pole jack with TV out |
| **Extras** | FM transmitter, stereo speakers, stylus |
| **Battery** | BL-5J, 1320 mAh, 3.7 V, 4.9 Wh |
| **Size and weight** | 111 x 60 x 18 mm, 181 g |
| **System** | Maemo 5 "Fremantle"; the last official version is PR 1.3 (2010); community update CSSU keeps it patched |

{: .warning}
> The figures come from the published Nokia data sheets. The memory and storage sizes I checked on a real phone. If you find a mistake, [open an issue](https://github.com/n900-resurrection/n900-resurrection.github.io/issues).

The component-by-component details (and how the kernel supports each part) are in the
[Commented Hardware specs](https://github.com/n900-resurrection/nokia-n900-notes/raw/main/doc/Nokia%20N900%20Commented%20Hardware%20specs.pdf) (PDF, 28 pages). Nokia's own
[Demo guide](https://github.com/n900-resurrection/nokia-n900-notes/raw/main/doc/Nokia%20Demo%20guide.pdf) is a good first look at what the phone does.

## What this means in practice

- **256 MB of RAM and one slow core:** command-line tools and small GTK 2 programs run well. A modern browser or anything built on Electron does not.
- **glibc 2.5 and an old kernel:** software has to be compiled for this system, see [cross-compiling for Maemo 5](https://github.com/n900-resurrection/n900-devkit). Our [repository]({{ '/packages/' | relative_url }}) does that for you.
- **Wi-Fi up to WPA2 and old TLS:** modern HTTPS needs a newer curl, which is why the repository comes with `apt-transport-curl`, see [Software setup](../software-setup/).
- **USB host:** with an OTG cable the phone can read a keyboard or a flash drive (this needs the community kernel "kernel-power"; I have not tested it myself).

