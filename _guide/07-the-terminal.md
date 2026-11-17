---
title: The terminal
order: 7
summary: How to get root access and use the command line
permalink: /guide/the-terminal/
---

For anything longer than a few commands it is easier to log in from a computer over ssh: [First ssh connection]({{ site.baseurl }}{% post_url 2026-11-13-first-ssh-connection-to-the-n900 %}).

## root

The applications **X Terminal** (package `osso-xterm`) and root access (`sudo gainroot`, package `rootsh`) come from the Extras repository, see [Software setup](../software-setup/).

`rootsh` is installable through Hildon Application Manager. You will need it in any circumstance where you need root access to your device.  

```bash
sudo gainroot
```

`rootsh` will ask for a sudo password, though, so on top of rootsh you can either install sudser, to be found here: 
[sudser](http://maemo.org/packages/view/sudser/)  
  
Or you can manually edit the sudo requirements in `/etc/sudoers.d/01sudo` and add sudo as a passwordless command.

- [maemo.org/Root_access](https://wiki.maemo.org/Root_access)

## Installation from `.deb` files

To install applications on Maemo 5, you can use `.deb` files. These files can be installed using the `dpkg` command.
```bash
dpkg -i <name>.deb
```