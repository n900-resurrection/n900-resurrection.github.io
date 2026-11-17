---
title: Software setup
order: 4
summary: Living repositories, root, ssh and the N900 Resurrection repository
permalink: /guide/software-setup/
---
The order of things on a phone that has just been taken out of a drawer. Each step has a longer story in the blog; here are the essentials.

## 1. Basics

Put the phone on **Wi-Fi** and make sure the **date and time are right** (certificates are checked, a wrong clock breaks HTTPS). If the battery is old and the phone loses the time, set it again after every start.

## 2. Throw out the dead repositories

The repositories that Maemo 5 ships with (`downloads.maemo.nokia.com`, `repository.maemo.org`, the Ovi store) no longer exist. Every refresh waits for their DNS errors and timeouts, and the Application Manager
can sit on "Checking for updates" for a very long time. **Remove them and keep only repositories that are alive and that you trust.** A package is installed as root, so do not add a source you cannot name the owner of.

- **Application Manager:** *Application catalogues*, edit or delete the dead entries. It regenerates `/etc/apt/sources.list.d/hildon-application-manager.list` from its own catalogues, so editing that file does not last.
- **Terminal:** the files in `/etc/apt/sources.list.d/` and `/etc/apt/sources.list`. Delete or comment out the dead lines.

## 3. A living Extras

The community applications (Extras) live on mirrors of the old server. Distribution `fremantle`, components `free non-free`; use **one** mirror at a time:

| Mirror | Address | State |
|---|---|---|
| plan9 | `http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras/` | snapshot of September 2017 |
| h4ck1ng.me | `http://n900.h4ck1ng.me/extras/` | snapshot of March 2026; run by an active member of the r/N900 community |
| viniciuspaes.com | `http://maemo.viniciuspaes.com/extras/` | copy of the original server; also firmware, flasher and the SDK (see [Resources](../resources/)) |

`extras-testing/` and `extras-devel/` exist on both too. Add them **only when you need a package from there**: their indexes are large (Extras-devel about 29 MB, Extras-testing about 9 MB) and the refresh gets slow.
**Do not type the addresses on the phone:** the [install files]({{ '/guide/install-files/' | relative_url }}) add a mirror (and can install an application from it) with one tap. Both mirrors are plain HTTP and unsigned, `apt-get update` prints `NO_PUBKEY` warnings (expected). More in [First ssh connection]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %}).

## 4. Root, terminal and ssh

From Extras: `osso-xterm` (the terminal), `rootsh` (`sudo gainroot`) and `openssh-server`. The whole procedure with the ssh configuration for a modern computer is in
[First ssh connection]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %}).

## 5. The N900 Resurrection repository

Modern software for the phone (curl 8, git, Python 3.11, mutt, gPodder, tools): the [package catalogue]({{ '/packages/' | relative_url }}). The apt of Maemo 5 speaks **TLS 1.0 only**, which GitHub refuses, so install two packages by hand first.

1. **Prerequisites** on the phone (as root): `dpkg -l bash3 coreutils-gnu | grep '^ii'`. The method is a bash script that needs `/bin/bash` and the GNU `mktemp` and `sha256sum`. If a package is missing, install it from Extras (step 3).
2. **Download** the newest `curl` and `apt-transport-curl` (**0.1-1maemo4 or newer**) from the [pool](https://n900-resurrection.github.io/n900-repository/pool/main/) on the computer and copy them to `/home/user/` of the phone (not to MyDocs, a FAT card cannot run programs).
3. **Install both together:** `dpkg -i curl_*_armel.deb apt-transport-curl_*_armel.deb`
4. **Add the source and refresh:**

```bash
echo "deb https://n900-resurrection.github.io/n900-repository fremantle main" > /etc/apt/sources.list.d/n900.list
apt-get update
apt-get install htop3
```

The repository is **not signed yet**: apt asks you to confirm packages without verification (answer yes, or `--force-yes`). For the Application Manager you can also open the [install file]({{ '/guide/install-files/' | relative_url }}) of this repository from the file manager. The details, the Fast Application Manager and troubleshooting
(`apt-transport-curl-check`) are in [Using the N900 repository on the phone]({{ site.baseurl }}{% post_url 2026-11-14-using-the-n900-repository %}).

