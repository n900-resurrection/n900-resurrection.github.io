---
layout: post
title: "Using the N900 repository on the phone"
author: elPytel
tags: [n900, maemo, apt, repository]
---
The packages of this project are served as a normal apt repository on GitHub Pages: <https://n900-resurrection.github.io/n900-repository>. A phone can use it like any apt source,
with one catch, explained below. This page is how I set it up on real N900s; I tested these exact steps on a clean second phone.

## Why two packages first

The apt of Maemo 5 (0.7.20) downloads `https://` addresses with its own method, which uses an old libcurl and OpenSSL 0.9.8: **TLS 1.0 only**. GitHub and most other servers refuse that
(`tlsv1 alert protocol version`). So before the repository can be added over HTTPS, apt needs a better `https` method. Two packages provide it:

- **`curl`**: curl 8 with TLS 1.2 and 1.3, which does the downloading;
- **`apt-transport-curl`**: a short script that replaces the apt method `https` and runs that curl. The original method is moved aside with `dpkg-divert` and comes back when you remove the package.
  Certificates are always verified.

The script is written for `bash` and uses the GNU `mktemp` and `sha256sum`, so the package also needs two system packages: **`bash3`** (it provides `/bin/bash`) and **`coreutils-gnu`**
(the GNU tools in `/usr/bin/gnu`; BusyBox on the phone has no `sha256sum` and its `mktemp` refuses a call without a template). A reader found a phone that had neither, and the method failed there.

## Step 0: check the prerequisites

As root on the phone, see whether the two system packages are installed:

```bash
dpkg -l bash3 coreutils-gnu | grep '^ii'
ls -l /bin/bash
```

If one is missing, install it first from the Extras repository (Application Manager, or `apt-get install bash3 coreutils-gnu` with the mirror from
[First ssh connection]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %})). Without them `dpkg -i` of `apt-transport-curl` in the next step refuses to install.

## Step 1: install curl and the transport by hand

apt cannot reach the repository yet, so these two files are installed by hand. Download them on the computer from the repository
([`curl`](https://n900-resurrection.github.io/n900-repository/pool/main/curl/) and
[`apt-transport-curl`](https://n900-resurrection.github.io/n900-repository/pool/main/apt-transport-curl/)); take the newest version of each
(for `apt-transport-curl` that is **0.1-1maemo4 or newer**, see the Application Manager note below). Copy them to the phone (for example with `scp`, see
[First ssh connection]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %}); to `/home/user/`, not to MyDocs: that card is FAT and cannot run programs) and install them **together, as root**:

```bash
dpkg -i curl_8.23.0-1maemo1_armel.deb apt-transport-curl_0.1-1maemo4_armel.deb
```

`apt-transport-curl` needs `curl`, `bash3`, `coreutils-gnu` and the system package `apt-transport-https` (a stock Maemo 5 has the last one). Make sure the **clock is right** (for example with `ntp-sync`), or the certificate check fails.

## Step 2: add the source and update

```bash
echo "deb https://n900-resurrection.github.io/n900-repository fremantle main" > /etc/apt/sources.list.d/n900.list
apt-get update
apt-get install htop3
```

The repository is **not signed yet**: apt prints `Ign ... Release.gpg` and asks for confirmation to install packages without verification. Answer yes, or use `apt-get install -y --force-yes <package>`.
The packages can be browsed on the [Packages page]({{ site.baseurl }}/packages/).

## If something is wrong

Run the check that comes with `apt-transport-curl` (as root):

```bash
apt-transport-curl-check
```

It prints the state of the installation and changes nothing: the three packages, the method files (`https` should be our script of about 5 kB, `https.distrib` the original of about 25 kB),
the handshake with apt, a test download over TLS, the clock, free memory, and the last lines of the method's error log. The result is a list of `[ ok ]` and `[FAIL]` lines and a `RESULT:` line
that you can paste into a bug report. If `curl` is missing the method says so (`install the package curl`) instead of dying silently.

## The Application Manager

[`n900-repository.install`](https://n900-resurrection.github.io/n900-repository/n900-repository.install) adds the catalogue to the built-in Application Manager and offers `apt-transport-curl`
(open the file from the file manager). The Application Manager pulls `curl` in as a dependency. Use **`apt-transport-curl` 0.1-1maemo4 or newer** (the hang was fixed in 1maemo3, 1maemo4 adds the dependencies): up to 0.1-1maemo2 the Application Manager
could hang for ever on "Preparing installation". The cause was a small race: the method wrote its first message to apt in two pieces (the lines, then the empty line that ends a message),
and the `apt-worker` of the Application Manager, woken by the first piece, read it, did not see the end of the message and never looked again. `apt-get` copes with a message in pieces, so
it worked in a terminal. Since 0.1-1maemo3 every message goes out in a single `write()`.

If the Application Manager still hangs for you, install with `apt-get` in a terminal and tell me what `apt-transport-curl-check` says.

## Keep the list of repositories short and alive

Maemo 5 ships with addresses of repositories that no longer exist (`downloads.maemo.nokia.com`, `repository.maemo.org`, the Ovi store). Every refresh tries them, waits for DNS errors, refused
connections and timeouts, and the Application Manager sits on "Checking for updates" much longer than it should. A reader who traced such a hang found it mostly came from these dead sources,
and from the huge development indexes (Extras-devel is about 29 MB of text, Extras-testing about 9 MB; the apt cache shrank from 24 MB to 3.5 MB after they were switched off).

So my advice: **remove every default repository and keep only the ones that are alive and that you trust**: the Maemo mirror
[plan9]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %}) (Extras; take Extras-testing and Extras-devel only when you need a package from there), this repository, and any other that is still maintained.
A repository you cannot name the owner of should not be on the list: every package is installed as root.

- **apt** (terminal): look at `/etc/apt/sources.list` and the files in `/etc/apt/sources.list.d/`, delete or comment out the dead lines, then `apt-get update`.
- **Application Manager**: it regenerates `/etc/apt/sources.list.d/hildon-application-manager.list` from its catalogue files, so editing that file does not last. Turn entries off in its own list
  (Application catalogues, then edit or delete), or, as the reader did, mark the built-in entries in `/etc/hildon-application-manager/catalogues` with `<disabled/>`:

```xml
<catalogue>
  <file>variant-catalogues</file>
  <id>nokia-certified</id>
  <disabled/>
</catalogue>
```

  (I have not tried this file edit myself; back it up first.) The old Nokia archives also report expired signing keys. That is a separate warning and not the cause of a hang.

## The Fast Application Manager

The Fast Application Manager (`fapman`) keeps **its own list of repositories** (`/root/.fapman/repos.list`), not the system one. To see our packages there, add the line
`deb https://n900-resurrection.github.io/n900-repository fremantle main` to its repositories and refresh. It runs `apt-get`, so the HTTPS method above is used.

One more thing about versions: community packages from Extras (`mc`, `git`, `openssh`) carry an epoch `1:` in their versions (`1:4.8.14` sorts above `4.8.33`), which made apt and the Fast Application Manager
offer those old packages as "updates" to ours. Our packages of the same names now have the epoch `1:` too, so the real version numbers decide.

## Known limits

- The repository is not signed yet.
- Some packages have a plain grey icon in the catalogue (they were packaged without one).
- Everything is tested on a few phones only. If something breaks for you, please tell me.
