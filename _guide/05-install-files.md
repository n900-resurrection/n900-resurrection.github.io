---
title: Install files
order: 5
summary: Add a repository or install an application with one tap
permalink: /guide/install-files/
---
Typing a long address on the keyboard of the phone is slow and error-prone. The Application Manager of Maemo 5 knows a better way: an **`.install` file**. It is a small text file that describes
a repository (and, if you want, a package to install from it). Open it and the Application Manager asks "Add this catalogue?" (and, for a package, "Install it?"), with no typing.

## How to use one

1. Download the file **on the phone** (the browser of the phone, from the table below) or copy it there from the computer (`scp file.install n900:/home/user/MyDocs/`).
2. Open it from the file manager (or from the browser's download list). The system recognises the extension `.install` and starts the **Application Manager**.
3. Confirm the new catalogue. The Application Manager refreshes its lists and the packages of the repository appear under *Browse installable applications*.

The Application Manager needs a working Internet connection, and the apt of the phone cannot do modern HTTPS: the files for the mirrors below are plain HTTP and work at once, the
file for our repository needs [`curl` and `apt-transport-curl`](../software-setup/) installed first.

## Files to download

Use **one** mirror of a repository at a time, and add Extras-testing or Extras-devel only when you need a package from there (their lists are large, see [Software setup](../software-setup/)).

| Repository | plan9 mirror (2017) | h4ck1ng.me mirror (2026) | viniciuspaes.com mirror |
|---|---|---|---|
| Extras | [extras-plan9.install]({{ '/install/extras-plan9.install' | relative_url }}) | [extras-h4ck1ng.install]({{ '/install/extras-h4ck1ng.install' | relative_url }}) | [extras-viniciuspaes.install]({{ '/install/extras-viniciuspaes.install' | relative_url }}) |
| Extras-testing | [extras-testing-plan9.install]({{ '/install/extras-testing-plan9.install' | relative_url }}) | [extras-testing-h4ck1ng.install]({{ '/install/extras-testing-h4ck1ng.install' | relative_url }}) | [extras-testing-viniciuspaes.install]({{ '/install/extras-testing-viniciuspaes.install' | relative_url }}) |
| Extras-devel | [extras-devel-plan9.install]({{ '/install/extras-devel-plan9.install' | relative_url }}) | [extras-devel-h4ck1ng.install]({{ '/install/extras-devel-h4ck1ng.install' | relative_url }}) | [extras-devel-viniciuspaes.install]({{ '/install/extras-devel-viniciuspaes.install' | relative_url }}) |
| Community SSU (testing) | [community-testing-plan9.install]({{ '/install/community-testing-plan9.install' | relative_url }}) | | |
| **N900 Resurrection** (needs `curl` + `apt-transport-curl`) | [n900-resurrection.install]({{ '/install/n900-resurrection.install' | relative_url }}) | | |

## What is inside

An install file is an ini file. This is the one for Extras on the h4ck1ng.me mirror:

```ini
[catalogues]
catalogues = extras-h4ck1ng-me

[extras-h4ck1ng-me]
name = Extras (mirror h4ck1ng.me 2026)
uri = http://n900.h4ck1ng.me/extras/
dist = fremantle
components = free non-free
```

- The first section lists the **ids** of the catalogues to add (`catalogues = ...`, separated by commas).
- Every catalogue has a section of its own, named by its id, with `name` (what the Application Manager shows), `uri` (the address of the repository), `dist` (always `fremantle`) and `components`
  (the sections of the repository: `free non-free` for Extras, `main` for ours).

The same file can also **install an application** from a catalogue. Add the key `package` to an `[install]` section and the Application Manager offers that package after it has added the catalogue:

```ini
[install]
catalogues = extras-h4ck1ng-me
package = mc

[extras-h4ck1ng-me]
name = Extras (mirror h4ck1ng.me 2026)
uri = http://n900.h4ck1ng.me/extras/
dist = fremantle
components = free non-free
```

{: .warning}
> The catalogue files follow the install files I have been using on the N900 for years (see the notes). The variant with `package` is the format of my old `mc.install`; I have not tried it with these mirrors on a freshly set up phone. If an install file does nothing, add the catalogue by hand under *Application catalogues* with the values above.

## One for every package

Every package in the [package catalogue]({{ '/packages/' | relative_url }}) has its own install file (the button **Install file for the N900** on its page). It adds the repository of this project and offers
that one package, so you can install an application without typing anything. It needs [`curl` and `apt-transport-curl`](../software-setup/) installed first. The files are generated from the repository, one per package, and live in `/install/packages/`.
