---
title: Resources for recovery
order: 6
summary: Where to get firmware, the flasher, mirrors and help when the official servers are gone
permalink: /guide/resources/
---
Nokia closed its servers and the community servers of Maemo (`repository.maemo.org`, `maemo.org`, the downloads) went away too. These are the places where the things needed to bring an N900 back to life survive.
Mirrors are run by volunteers and can disappear, so **keep your own copy** of what you need (the flasher, the firmware image, a few `.deb` files).

## Mirrors of the Maemo repositories

All three are plain HTTP and unsigned (`apt-get update` warns about missing keys). Use one at a time, the [install files]({{ '/guide/install-files/' | relative_url }}) add them without typing.

| Mirror | What it has |
|---|---|
| [maemo.viniciuspaes.com](https://maemo.viniciuspaes.com/) | Extras, Extras-testing, Extras-devel (also for the older releases Diablo, Bora and others), the SDK repositories for Fremantle, and the directories `/firmware/`, `/flasher/` and `/development/`. It asks not to be cloned by robots, take what you need. |
| [maemo.plan9.de](https://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/) | A snapshot of the whole repository from September 2017: Extras, Extras-testing, Extras-devel, Community SSU, and the SDK. About 62 GB in all. |
| [n900.h4ck1ng.me](http://n900.h4ck1ng.me/) | Extras, Extras-testing, Extras-devel of March 2026, run by a member of the r/N900 community. |

The `Packages` index of the Extras `free` section has exactly the same size on the h4ck1ng.me and viniciuspaes.com mirrors (6 609 594 bytes), so they most likely hold the same snapshot, I have not compared plan9 in detail. The choice is mostly about which one is up.

## Firmware and the flasher

A phone that does not start, or that you want to reset to the last official Nokia system (PR 1.3), is reflashed from a computer over USB. You need two things: the **flasher**  and a **firmware image**. Both are listed on
[maemo.viniciuspaes.com](https://maemo.viniciuspaes.com/) (directories `/flasher/` and `/firmware/`, I have not downloaded them, check the files and their checksums yourself). The community update **CSSU** (Community SSU) goes on top of the official system and keeps it patched, it is in the plan9 mirror (`community-testing`).

{: .warning}
> Flashing can brick a phone if it is interrupted. Charge the battery first, use a good cable, and read the instructions that come with the flasher and with the image. I have not reflashed any of my phones for this guide.

## Documents and help

- **User guides (PDF):**
  - [Nokia N900 Demo guide](https://github.com/n900-resurrection/nokia-n900-notes/raw/main/doc/Nokia%20Demo%20guide.pdf) (24 pages, 1.6 MB): Nokia's own tour of the phone and of Maemo 5.
  - [Nokia N900 Commented Hardware specs](https://github.com/n900-resurrection/nokia-n900-notes/raw/main/doc/Nokia%20N900%20Commented%20Hardware%20specs.pdf) (28 pages, 10 MB): every component of the N900 and how the Linux kernel and the Maemo 5 binaries support it (a page of the Maemo community wiki saved in 2015).

- The **notes** this guide grew from: [nokia-n900-notes](https://github.com/n900-resurrection/nokia-n900-notes) (an archive).
- **r/N900** on Reddit: an active community, where this project started.
- **Maemo Leste**: a modern Debian-based Linux with the Hildon desktop, also for the N900 and a few other phones. It is a different system from Maemo 5, packages here do not run on it.
- **[talk.maemo.org](https://talk.maemo.org/)**: the old Maemo forum, still online when I checked, with years of how-tos and bug threads. A copy in the Internet Archive: [web.archive.org/web/2026/https://talk.maemo.org/](https://web.archive.org/web/2026/https://talk.maemo.org/) (the Wayback Machine also has the old `repository.maemo.org`, see the [notes](https://github.com/n900-resurrection/nokia-n900-notes)).

If a link on this page is dead when you read it, please [open an issue](https://github.com/n900-resurrection/n900-resurrection.github.io/issues).
