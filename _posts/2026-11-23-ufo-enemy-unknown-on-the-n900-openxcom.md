---
layout: post
title: "UFO: Enemy Unknown on the N900 with OpenXcom"
author: elPytel
tags: [n900, maemo, games, openxcom, xcom, cpp]
---
**X-COM: UFO Defense** (1994) is one of the best strategy games ever made, and **[OpenXcom](https://openxcom.org)** is an open-source reimplementation of its engine. It runs the original game from the original data, with a touch screen as the mouse. Now it runs on the N900 too. The package is in our repository; the game itself is **not** (more on that below).

This post is the short version of how to use it, and the longer version of what went wrong on the way. Most of the evening went on four problems, and each of them will hit anyone who brings a game that uses SDL 1.2 to the N900.

## What you need

- **Your own copy of UFO: Enemy Unknown.** OpenXcom contains only the engine. The graphics, maps and sounds are the original ones. The DOS version works (for example the folder you use with DOSBox), and so should the Steam and GOG versions (those I did not try). Copy the folder, which has `GEODATA`, `MAPS`, `SOUND`, `UFOGRAPH` and so on, in any letter case, to the memory card, for example `MyDocs/X-Com`.
- The package, after [adding the repository]({{ '/guide/software-setup/' | relative_url }}), as root on the phone:

```bash
apt-get install openxcom       # needs libsdl-mixer1.2 and libsdl-image1.2, the phone has them
```

Start **OpenXcom** from the menu ([package page]({{ '/packages/openxcom/' | relative_url }})). The launcher looks for the game in `MyDocs/X-Com`, `MyDocs/UFO`, `MyDocs/Games/...` and then anywhere in `MyDocs`. It makes a folder of links, `~/.openxcom/data`, so nothing of the original game is copied or changed. **The game needs about 30 seconds to start**: it loads its rulesets and the graphics, and the phone has a 600 MHz processor.

## How it is played

- **The touch screen is the mouse.** A tap is a left click, and the whole game works with it.
- **Cursor keys** scroll the globe and the map; letters and digits are the usual OpenXcom shortcuts.
- **Ctrl is Esc.** The N900 has no Esc key, and OpenXcom uses it to cancel dialogs and to open the options. The launcher sets Ctrl in its place.
- **Tab** (detail level of the globe, next soldier in a battle) is not on the keyboard; change the key in the options of the game.

## What was tested, honestly

On **one phone**, with the DOS version of the game: the game starts and shows its menus, the touch screen works, the keyboard works (I typed the name of a base), the intro plays and the keyboard still works after it, Ctrl cancels a dialog. The package has 12 tests that run on the phone.

**Not tested:** a whole battle, so I do not know how fast the tactical part is on this processor; saving and loading; music and sounds; the Steam and GOG versions; the demo of the game. The phone has 245 MB of memory, so close other applications first. If you try a battle, I would like to hear how it went.

## What went wrong

**1. C++ for a 2008 system.** OpenXcom is C++11, and the phone has `libstdc++` 4.2.1. The way out is to take the `libstdc++.a` of a modern cross compiler and link it **statically**. But that library was built for glibc 2.39 and a 64-bit `time_t`, and the phone has glibc 2.5 and a 2.6.28 kernel, so it asks for functions that do not exist there (`getentropy`, `__clock_gettime64`, a 112-byte `struct stat` and a few dozen more). A small shim file supplies them, translating the 64-bit time calls to the old ones. This became the repository **[maemo-toolchain](https://github.com/n900-resurrection/maemo-toolchain)** with `maemo-g++`, which compiles C++17 for Maemo 5, including threads, exceptions, `<filesystem>` and `<regex>`, and has a self-test that runs under `qemu-user` and on the phone. It is useful for any C++ program, not only for this one.

**2. "GEODATA/PALETTES.DAT not found".** OpenXcom 1.0 looks a file up in only three ways: the exact name, the whole path in UPPER case, the whole path in lower case. The original game in `MyDocs` is in lower case, but the engine's own `MAPS`, `ROUTES` and `TERRAIN` folders are in upper case, so `TERRAIN/BLANKS.TAB` was found by none of the three, and the game complained about one file after another. The launcher now builds the data folder as folders of links with upper-case names, merging the original files with the engine's.

**3. The touch screen worked, the keyboard did not.** This took the longest. A small SDL test program that logs every event showed that a plain SDL window gets keys. OpenXcom's window did not, and its own log showed no key event at all. There were two causes:

- With a 640x400 window on the 800x480 screen SDL cannot change the screen mode, and the window gets no keyboard focus. With the display set to **800x480 and full screen** it does (and the picture is scaled much better, which is a bonus).
- OpenXcom calls `SDL_WM_GrabInput(captureMouse)` at the start, and with the default "off" SDL does not grab the keyboard of a full-screen window, so the keys go to the desktop. **`captureMouse: true`** fixes it, and the keys appeared at once.

If an SDL 1.2 program on the N900 shows a picture and reacts to touch but not to keys, look at these two things first.

**4. Smaller things:** there is no Esc key (Ctrl instead); the "press any key" error screen waited for a key on the standard input and never went away, because I had started the game over ssh; `options.cfg` is rewritten when the game ends, even after `kill`, so a change made while it runs is lost; and the game crashes at the start, before it writes any log, when it is started from a folder that the user cannot read (`su user` from a root shell leaves the current folder at `/root`). The launcher changes to the home folder first. The README of the package lists all of them.

## Where it is

The package and the launcher: [openxcom](https://github.com/n900-resurrection/openxcom). The engine is the unmodified OpenXcom 1.0 (GPL-3, SDL 1.2), compiled by `build.sh`; SDL_mixer and SDL_image are the phone's own, SDL_gfx and yaml-cpp are linked statically. The game itself is the work of Mythos Software and MicroProse and belongs to its owners; this is only the engine that lets you play your own copy.
