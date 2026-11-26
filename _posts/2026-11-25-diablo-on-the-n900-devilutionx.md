---
layout: post
title: "Diablo on the N900 with DevilutionX"
author: elPytel
tags: [n900, maemo, games, diablo, devilutionx, sdl2, cpp]
---
**Diablo** (1996) on a phone from 2009: **[DevilutionX](https://github.com/diasurgical/devilutionX)** is an open-source engine that runs the original game data on modern systems, and it now runs on the N900. About 30 frames per second, the touch screen works as the mouse, sound and music play. The engine is built by us; the game data is **not** included (more on that below).

![Blizzard North logo on the N900]({{ '/assets/diablo/blizzard-north.png' | relative_url }})

## What you need

- **Your own game data.** `DIABDAT.MPQ` from the original Diablo (517 MB), or `spawn.mpq` from the shareware version, which is free to download. The file does not fit into the home folder of the phone, so put it on the memory card: `MyDocs/diablo`. The launcher finds it there (and in `~/.local/share/diasurgical/devilution/` or anywhere in `MyDocs`, in any letter case).
- The engine: a package built from our sources ([nokia-n900-apps](https://github.com/n900-resurrection/nokia-n900-apps), `apps/devilutionx`, built with [n900-devkit](https://github.com/n900-resurrection/n900-devkit)). It is not in the repository yet.

Start **Diablo** from the menu. The phone has 245 MB of RAM and the game leaves 3 to 17 MB free, so close other programs first, and do not install packages while it runs.

![The main menu of Diablo on the N900]({{ '/assets/diablo/diablo-menu.png' | relative_url }})

## How it was built

DevilutionX needs C++20 and SDL 2. We had SDL 2 for Maemo 5 already (it came with Abuse and Chocolate Doom: X11, software renderer, no GPU), and it is enough for 800×480. The network play is switched off (no ZeroTier, no libsodium), as are the tests and the Discord integration. The package is about 7 MB.

Before I trusted the 517 MB data file, I checked it: a valid MPQ header, all 2910 files inside the archive, the size of the original data, no executable code appended. A large file from the network can carry something that does not belong there.

## What went wrong

1. **It crashed right after the Blizzard logo.** The engine looks for its own `devilutionx.mpq` (fonts and interface) only in the data and preference folders, not in `/opt`. It printed `Missing file: fonts\24-00.pcx` and died with a segmentation fault. The launcher now links the archive into the preference folder.
2. **A white square flickered around the mouse hand.** The engine uses a hardware cursor, and the X libraries of the phone lack the functions it needs (`XcursorImageCreate: undefined symbol`). The launcher sets `Hardware Cursor=0` in `diablo.ini`, and the game draws the hand itself.
3. **Sound but no picture** came from my own test: started over ssh without `DISPLAY=:0`, the game ran without a window. From the menu it works.

## How it plays

Smooth, about 30 frames per second, scaled to the whole screen, and the menus can be tapped. I made a character, the map loaded, and the skeletons cut me down in the catacombs, which is the best proof that it runs. Not tested yet: a long game in one go (the sound was silent once after the intro in an earlier build, it plays in the current one) and saving; this is tracked in [issue #2](https://github.com/n900-resurrection/nokia-n900-apps/issues/2).
