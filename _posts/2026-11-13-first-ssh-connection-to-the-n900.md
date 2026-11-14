---
layout: post
title: "First ssh connection to the N900 (and the plan9 repository)"
author: elPytel
tags: [n900, maemo, ssh, plan9, apt]
---
Most things on the N900 are easiest from a computer: copying files, running commands, building packages. For that you need an ssh server on the phone.
Nokia did not ship one, and since the official repositories are gone it has to be installed from somewhere else. This is the guide for a clean phone
(tested on a second N900 with Maemo 5, PR 1.3).

## What you need

- The N900 on **Wi-Fi** and with the **right date and time** (otherwise certificate checks fail).
- A **terminal on the phone** (the package `osso-xterm`, the X Terminal icon) and **root** (`sudo gainroot`, package `rootsh`). Both are in Extras (and on the plan9
  mirror of step 1); if they are missing, install them with the Application Manager first. The commands of steps 1 and 2 are typed as root.
- `ssh` and `ssh-copy-id` on the computer (Linux, macOS or WSL).

## Step 1: the plan9 repository

The official `repository.maemo.org` is dead. The mirror **`maemo.plan9.de`** is alive, though: a snapshot of the whole repository from 2017 with a huge number of packages
(Extras, Extras-testing, the SDK and more). It has one advantage: it is plain **HTTP**, so even the old `https` method of apt, which cannot do modern TLS, is not needed.

Add the sources (through the Application Manager's *Application catalogues*, or directly in a file). In a terminal as root:

```bash
cat > /etc/apt/sources.list.d/plan9.list <<'EOF'
deb http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras/ fremantle free non-free
deb http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras-testing/ fremantle free non-free
deb http://maemo.plan9.de/apt-mirror/mirror/repository.maemo.org/extras-devel/ fremantle free non-free
EOF
apt-get update
```

`apt-get update` prints warnings like `GPG error ... NO_PUBKEY ...`. That is expected: the mirror has no key the phone knows. The packages download and install through `apt-get` normally.

{: .warning}
> This is a third-party mirror over HTTP, without signatures. Packages are installed as root and nobody verifies that they are faithful copies. I do the same on my own phones,
> but you should know it. Be careful with `extras-devel`: it holds work in progress.

## Step 2: the ssh server on the phone

The server is the package `openssh-server` (version 5.1) from Extras:

```bash
apt-get install openssh-server
```

Then set the **root password** and start the server:

```bash
passwd
/etc/init.d/ssh start
ps | grep sshd
```

Mind the last command: its output always includes the line of `grep sshd` itself. The server runs only when there is **another** line with `/usr/sbin/sshd -D`. If you see only the
`grep` line, the server is not running (I misread this on my first try).

After a reboot the server starts by itself (the upstart job `sshd`).

## Step 3: the address of the phone

On the phone:

```bash
ifconfig wlan0 | grep "inet addr"
```

Write the address down (for example `192.168.1.50`). It is a good idea to have the router give the phone a fixed address.

## Step 4: connecting from the computer

A naive `ssh root@192.168.1.50` ends like this today:

```
Unable to negotiate with 192.168.1.50 port 22: no matching host key type found. Their offer: ssh-rsa,ssh-dss
```

Current OpenSSH on the computer no longer allows the old key type `ssh-rsa` by default, and the server on the phone offers nothing else. The fix is to allow it **for this one device**
only. In `~/.ssh/config` on the computer:

```
Host n900
    HostName 192.168.1.50
    User root
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedAlgorithms +ssh-rsa
    SetEnv TERM=xterm
```

Now `ssh n900` is enough. The first connection asks whether to trust the key fingerprint: answer `yes`, then enter the root password from step 2.
(`SetEnv TERM=xterm` fixes the display in the terminal, the phone does not know newer terminal types.)

## A key instead of a password

You do not want to type the password every time, and above all you do not want the phone to accept a password login. Copy your public key:

```bash
ssh-copy-id n900
```

You enter the password for the last time. From then on `ssh n900` lets you in without one. If `ssh-copy-id` does not use the alias, add the two options by hand:
`ssh-copy-id -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa n900`.

## Errors I ran into

| Error | Cause and fix |
|---|---|
| `Connection refused` on port 22 | The ssh server is not running or not installed. On the phone `ps \| grep sshd` (look for the second line) and `/etc/init.d/ssh start`. |
| `no matching host key type found` | `HostKeyAlgorithms +ssh-rsa` is missing in `~/.ssh/config`, or you call `ssh` without the alias. |
| `Permission denied (publickey)` after changing the server | The root password is not set (`passwd`), or the key is not in `/root/.ssh/authorized_keys`. |
| `Connection timed out` | Wrong address, the phone is asleep (Wi-Fi), or another subnet. Try `ping` and `ifconfig` on the phone. |
| `WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED` | The phone was reinstalled and has a new server key. `ssh-keygen -R 192.168.1.50` and connect again. |
| `NO_PUBKEY` during `apt-get update` | Expected, the mirror has no key. Ignore it. |

## Security

- The 5.1 server dates from 2009 and allows **root with a password**. At home behind a router this is acceptable; on foreign Wi-Fi or on mobile data do not leave it running.
- After copying your key, turn passwords off: in `/etc/ssh/sshd_config` set `PasswordAuthentication no` and run `/etc/init.d/ssh restart`. Check first that the key login works.
- A modern ssh server (OpenSSH 10) is also in our repository as the package `openssh`. It lives in `/opt/openssh`, listens on port 2222, takes keys only, for the user `user`, and does not start by itself.
  It is good for fine-tuning; for the first connection the system `openssh-server` is simpler.

## What next

Once you can reach the phone over ssh you can add our own repository with more packages: see [Using the N900 repository]({{ site.baseurl }}{% post_url 2026-11-14-using-the-n900-repository %}),
which explains why `apt-transport-curl` is needed for HTTPS.
