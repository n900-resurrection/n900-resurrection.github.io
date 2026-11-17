---
layout: post
title: "Neverball on the N900: tilt the phone, roll the ball"
author: elPytel
tags: [n900, maemo, games, neverball, accelerometer]
---
[Neverball](https://neverball.org/) is a classic: you tilt the floor of a 3D course and the ball rolls on it, collecting coins before the time runs out. The N900 has an accelerometer, so tilting the *phone* to tilt the floor
is exactly what it is made for. I was about to start compiling Neverball for the phone, when I found that **it already exists for Maemo 5**, in Extras. This is how to install it today, when the official repositories are gone,
and how it plays.

## What is in Extras

Neverball and its golf sibling Neverputt were ported to Maemo 5 by Alberto Mardegan in 2010 (version 1.5.5-3). The packages:

| Package | Size |
|---|---|
| `neverball` (the program) | 116 kB |
| `neverball-common` (data for Neverball and Neverputt) | 16.8 MB |
| `neverball-data` (levels of Neverball) | 22.5 MB |
| `neverputt`, `neverputt-data` (the golf game) | not tried yet |

The port draws with **OpenGL ES 1.1** through the library `libsdl-gles1.2` and reads the **accelerometer** of the phone. According to the author, it is slower than Neverputt, because the physics is heavy for the processor.

## The dependencies that are not in Extras

`apt-get install neverball` does not work on a phone with only Extras, because two libraries come from elsewhere:

- **`libgles1-sgx-img`**: the OpenGL ES 1 library of the graphics chip. A stock phone has the GLES 2 library, but this one was left out. It is in the **system update repository of Nokia** (`ssu/206`, the last one) on the mirror of the Nokia catalogues. Take care of the version: the older catalogue `apps` on the same mirror has `0.20090218`, which refuses to install next to the
  `opengles-sgx-img-common 0.20100611` that the phone has since the last firmware (PR 1.3). The `ssu/206` one is `0.20100611.6`, which matches.
- **`libsdl-ttf2.0`** (fonts): I found it in the SDK repositories of the mirror `maemo.viniciuspaes.com` only. Neither Extras nor the Nokia catalogues had it.

## Installing it

On the phone, as root (see [The terminal]({{ '/guide/the-terminal/' | relative_url }})). The sources first:

```bash
echo "deb http://n900.h4ck1ng.me/extras/ fremantle free non-free" > /etc/apt/sources.list.d/extras-h4ck1ng.list
echo "deb http://maemo.linenoise.info/downloads.maemo.nokia.com/fremantle/ssu/206/ ./" > /etc/apt/sources.list.d/nokia-ssu.list
echo "deb http://maemo.viniciuspaes.com/ fremantle/sdk free" > /etc/apt/sources.list.d/sdk-tmp.list
apt-get update
apt-get install -y --force-yes neverball
rm /etc/apt/sources.list.d/sdk-tmp.list
```

The mirrors are plain HTTP and unsigned (the key of the Nokia catalogue has expired), so `apt-get update` prints warnings and `--force-yes` is needed; see [Software setup]({{ '/guide/software-setup/' | relative_url }}).
The last line removes the SDK repository again: it is large and only the font library came from it. The installation takes about 62 MB of data in `/opt` and a few hundred kilobytes in the system, so the small root file system hardly changes.
The game appears in the menu as **Neverball**.

{: .warning}
> `ssu/206` is a repository of *system* updates, so run `apt-get upgrade` on a phone with this source only after looking at what it wants to change, or take the line out again when you are done.

(An [install file]({{ '/guide/install-files/' | relative_url }}) cannot do all of this at once, because the packages come from three different catalogues. That is why the sources are added by hand.)

## How it plays

This is my first impression on a real N900, not a review:

- **It looks like a Flash game from 2010 on a laptop from 2006**, which is about what one expects from this hardware and a port of this age.
- **It responds well**, with **occasional drops of the frame rate**.
- **The tilt works**, but [Bounce Evolution]({{ site.baseurl }}{% post_url 2026-11-17-bounce-evolution-on-the-n900 %}) is more playable. That one was written for the N900, and Neverball is an old PC game that was ported.
- **The camera turns when the ball hits a wall**, and the turn adds to your tilt, so you have to correct the ball more. This is the default "chase" view: the camera swings behind the direction in which the ball moves, so the direction of the tilt moves with it.
  The game has three views, **Chase**, **Lazy** and **Manual**, and its own hint says that for tilt in two directions the manual view is best. By the default keys (from the source of the newer 1.6, so check them in your version) they are **1**, **2** and **3**, which on the N900
  keyboard are `Fn`+`Q`, `W` and `E`. I have not tried this yet.
- The options of the game have switches for **textures, reflections, background and shadows**: switching them off should help the frame rate.

If you try it, I would like to know how the manual view works and whether Neverputt is better.

## If you want to compile it yourself

The current Neverball (1.6) needs SDL 2, which Maemo 5 does not have, and OpenGL ES 1, while the phone's own libraries are GLES 2, so a port would take some work. The accelerometer is easy:
it is a file, `/sys/class/i2c-adapter/i2c-3/3-001d/coord`, with three numbers `x y z`. I have it on my list for later, but the existing port is enough for now.
