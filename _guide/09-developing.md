---
title: Developing for the N900
order: 9
summary: "The Maemo 5 SDK today: what survives, why it is hard, and the modern way"
permalink: /guide/developing/
---
To write a program for the N900 you need a compiler that makes code for the phone (ARM, glibc 2.5), the headers and libraries of Maemo 5 to compile against, and a place to try the result. Nokia
supplied all of it as the **Maemo 5 SDK** in 2009 to 2011. This page says what is left of it, where to find it, and how this project works around the rest.

## What the original SDK was

- **Scratchbox 1**: a 32-bit Linux environment (a chroot with its own compilers and an ARM emulator) that cross-compiled for the phone. It ran on an old Debian or Ubuntu of the time.
- **Two "targets"**: the *armel* target, which is the system of the phone as a set of headers and libraries (`maemo-sdk-dev` and friends), and an *i386* target for testing on the PC, together with the Maemo desktop in an X server (Xephyr).
- **An installer** that downloaded all of it from `repository.maemo.org`: the scripts `maemo-sdk-install_5.0.sh` and `maemo-scratchbox-install_5.0.sh`, and the graphical `maemo-sdk-install-wizard_5.0.py`.
- **Nokia binaries**: closed parts of the SDK, from a repository (`nokia-binaries`) that needed a personal **token** from Nokia and agreement to a licence.

## What survives, and where

The mirror [maemo.viniciuspaes.com](https://maemo.viniciuspaes.com/) keeps a copy (see [Resources for recovery]({{ '/guide/resources/' | relative_url }})). It lists, as of 17 November 2026:

| What | Where |
|---|---|
| The installer scripts and the wizard (August 2011), the checksums `MD5SUM`, the release notes of the SDK 1.7 | `http://maemo.viniciuspaes.com/stable/fremantle/` |
| The package lists of the SDK for the armel target (2702 + 32 packages) and of its tools (186 + 3) | `deb http://maemo.viniciuspaes.com/ fremantle/sdk free non-free` and `deb http://maemo.viniciuspaes.com/ fremantle/tools free non-free` |
| The same pool for browsing and download | `http://maemo.viniciuspaes.com/pool/fremantle` |
| The closed Nokia part | `deb http://maemo.viniciuspaes.com/ fremantle/<token-code> nokia-binaries`: the token is not explained anywhere and Nokia no longer gives it out |

The mirror's own note says these repositories are meant to be used with `apt-get` **inside the SDK environment**, and asks people not to clone the whole site with robots. The plan9 mirror
(`maemo.plan9.de`) has a snapshot of the SDK repositories of September 2017 as well.

{: .warning}
> I have checked that the two `fremantle/sdk` and `fremantle/tools` repositories are readable with the apt of a phone and that the directory of the installers lists the files above. I have **not** downloaded the installers,
> and have not run them: their state on a current computer is unknown to me.

## Why the old SDK is hard to use now

- **Scratchbox 1 does not like modern Linux.** It is built for an old 32-bit userland and old kernels, and it is known to misbehave on current ones. The mirror's own page for the N800 recommends a Debian 6 (Squeeze) in a virtual machine for it,
  which tells you how old the environment is.
- **The scripts talk to servers that are gone.** They download from `repository.maemo.org`, so they have to be pointed at a mirror by hand.
- **The token** for the Nokia binaries: without it some parts of the target are missing.
- **It is slow and heavy:** several gigabytes, an emulated build, and an old compiler (the SDK's GCC is from the 4.x series, my memory says 4.2) that much current source code does not compile with.

## The modern way: the development kit

This project does not use Scratchbox. It uses **[n900-devkit](https://github.com/n900-resurrection/n900-devkit)**, which needs only a current Linux computer:

- a **Workshop** container (Ubuntu with LXD) with a **modern GCC cross-compiler** for ARM (`arm-linux-gnueabi`), and a wrapper `maemo-gcc` that links against glibc 2.5 of the phone;
- the **sysroot**: the headers and libraries of Maemo 5, assembled from the SDK packages of the community mirrors (about 90 MB), with a script (`make sysroot`);
- an **emulated Hildon desktop** on the PC: the real ARM programs run under `qemu-user` against the real GTK 2.14 and Hildon 2.2 libraries, on a virtual 800 x 480 screen. You can try a GUI program without the phone;
- examples (a C hello world, a Python 3 GUI application) and documentation in English.

You get a working cross-compiler, the libraries and an emulator in a few commands. The kit has what the old SDK had for building a program, minus the closed Nokia parts. What it cannot do is replace the phone for hardware (camera, radios, sensors).

### Read next

- [The N900 emulator on your PC: no phone needed]({{ site.baseurl }}{% post_url 2026-11-15-the-n900-emulator-on-your-pc %}): how to start the emulator and what it shows.
- [Your first N900 GUI app in Python 3]({{ site.baseurl }}{% post_url 2026-11-16-your-first-n900-gui-app-in-python-3 %}): writing and testing an application without a phone.
- The documents of the kit: [getting started](https://github.com/n900-resurrection/n900-devkit/blob/main/docs/getting-started.md), [cross-compiling for Maemo 5](https://github.com/n900-resurrection/n900-devkit/blob/main/docs/cross-compile.md),
  [the emulator](https://github.com/n900-resurrection/n900-devkit/blob/main/docs/emulator.md), [Python GUI](https://github.com/n900-resurrection/n900-devkit/blob/main/docs/python-gui.md).
- The packages of this project are built with the kit: [the package catalogue]({{ '/packages/' | relative_url }}).

## If you still want the old SDK

You can try it in a virtual machine with an old Debian or Ubuntu, and edit the installer to use `maemo.viniciuspaes.com`. For a project that only needs to cross-compile C or Python code, the kit above is much less work.
