---
title: Using the N900
order: 3
summary: Desktop, keyboard, terminal and the usual first steps
permalink: /guide/using-the-n900/
---
A short orientation for someone who has the phone in the hand for the first time. (This page is still growing; I add what I have verified myself.)

## The desktop

- **Four home screens** that you swipe sideways. Hold the empty background (or use the menu) to put widgets and shortcuts on them.
- **The top left corner** opens the **application switcher**: the open programs as a grid of thumbnails. Tap one to go there, tap the cross on it to close it.
- **The title of the window** (the top bar of an application) opens that application's **menu**.
- **The top right corner** is the status area: signal, battery, clock; a tap opens the status menu with connections and profiles.
- **The back and close buttons:** a program has a small arrow or cross in the top right corner of its window.
- **Touch:** the screen is resistive, so it needs a small push, but it also works with the stylus or a fingernail. Pinch zoom is not available, the volume keys zoom instead where it makes sense.

## The keys

- **Power key** (top edge): a short press locks the phone or opens the menu with the profiles, a long press asks to switch it off.
- **Lock slider** (side): slides to unlock the screen and keys.
- **Volume / zoom** (side) and the two-stage **camera key**.
- **Keyboard:** slide the screen up. `Fn` and `Chr` give the digits, symbols and accented letters; the layout is changed under *Settings, Text input*. The `Ctrl` key works as on a PC (`Ctrl+C`, `Ctrl+V`, `Ctrl+X`).

## The terminal

The applications **X Terminal** (package `osso-xterm`) and root access (`sudo gainroot`, package `rootsh`) come from the Extras repository, see [Software setup](../software-setup/).
For anything longer than a few commands it is easier to log in from a computer over ssh: [First ssh connection]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %}).

## Two things to know

- **Free space on `/`** is small (see the [specifications](../specifications/)). Install large things to `/opt` or `/home`, and keep an eye on `df -h`.
- **Batteries and heat:** the phone drains fast when Wi-Fi, GPS and the screen are all on, and a battery from 2009 holds much less than a new one. A new BL-5J is the best upgrade you can buy.

