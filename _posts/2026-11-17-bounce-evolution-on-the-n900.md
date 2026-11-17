---
layout: post
title: "Bounce Evolution: Rovio's 3D demo for the N900, and where to find it today"
author: elPytel
tags: [n900, maemo, games, bounce, rovio]
---
**Bounce Evolution** is a small 3D game that **Rovio Mobile** made for the N900 in 2009. Nokia published it (the Bounce trademark is Nokia's), first as a beta that N900 owners could get for free from the Ovi Store.
It was meant to show what the graphics chip of the N900 can do, and it was never developed into a full game; it stayed a *technology demo*. The Ovi Store is long gone, so here is where the game can still be found and how to put it on a phone.

## What it is

The package says "Playable 3D technology demo for N900". From what the community has written down about it (the fan port Redbound documents it well):

- the game has **two levels**: a countryside level in which you collect 14 apples and solve a puzzle with logs, and a rail-based arcade level with boost arrows, slow zones and time arcs, scored against records;
- on the N900 you **tilt the phone** to move (the accelerometer), and the phone vibrates;
- it has an attraction demo, a menu, a pause menu and credits.

## Where to get it

The `.deb` package survives on the mirror of the Nokia catalogue, and on ModDB:

| Version | File | Where |
|---|---|---|
| **1.0.1** (the one to use) | `bounce_1.0.1_armel.deb`, 15 267 814 bytes | [maemo.linenoise.info, `ovi/`](http://maemo.linenoise.info/downloads.maemo.nokia.com/fremantle/ovi/bounce_1.0.1_armel.deb); [ModDB](https://www.moddb.com/games/bounce-evolution/downloads/bounce-evolution) has the same size |
| 1.0.0 | `bounce_1.0.0_armel.deb`, 15 268 666 bytes | [maemo.linenoise.info, `apps/`](http://maemo.linenoise.info/downloads.maemo.nokia.com/fremantle/apps/bounce_1.0.0_armel.deb) |

Check the file after the download, so you know you have the original:

```
sha256sum bounce_1.0.1_armel.deb
09e0b3abc8c422ffaa3a2fca7e796749d6ad6797137b840d84e28938c6401ab4
```

(MD5 `989bbf1ce9db06725b4bcb51a75741ea`.) That is also the checksum that the fan port Redbound expects. I do not host the game: it is Rovio's and Nokia's work, so this page only points to the copies that already exist.

## Installing it on the phone

Copy the file to the phone (to `/home/user/`, not to the MyDocs card) and install it as root, with the [terminal]({{ '/guide/the-terminal/' | relative_url }}):

```bash
dpkg -i bounce_1.0.1_armel.deb
```

The game takes about 22 MB in `/opt/bounce`, so it goes to the big partition and the small root file system is nearly untouched (it only gets the menu entry and an icon). The package needs only system libraries
(`libc6`, `libpulse0`, `libpng12-0`, `libstdc++6`, `libx11-6` and a few more), which a stock Maemo 5 has. It shows up in the menu as **Bounce**. The package is marked as hidden, so you will not find it in the lists of the Application Manager.
Remove it with `dpkg -r bounce`.

### With an install file

The Application Manager can also fetch it from the Nokia catalogue mirror: [bounce-evolution.install]({{ '/install/bounce-evolution.install' | relative_url }}) adds the catalogue and offers the package, as in
[Install files]({{ '/guide/install-files/' | relative_url }}). The catalogue has all the old Nokia "Ovi" apps of the Maemo 5 times, not only this game.

## What came after

- [Redbound](https://github.com/alox-dev/redbound) is a source port of Bounce Evolution that runs natively on modern devices, with the original levels, physics and sound. It needs **your own copy of the original package** and does not include any game data, which makes the checksum above useful.
- [reBounce](https://github.com/myname24/rebounce-vita) is a port to the PlayStation Vita, with the same requirement.

If you play it, I would be glad to hear how it runs on your phone, and whether the tilt control is still comfortable.
