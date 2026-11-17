---
layout: page
title: Nokia N900, again
---
<p class="lead">The N900 is a 2009 phone with a real keyboard and a Linux inside. This project makes it useful in 2026: modern TLS, current tools, a package repository you can use from the phone itself, all built with <strong>Claude</strong> and tested on real devices.</p>

<p><a class="button" href="{{ '/packages/' | relative_url }}">Browse the packages</a> &nbsp; <a href="{{ '/guide/' | relative_url }}">Read the guide</a> &nbsp; <a href="{{ '/blog/' | relative_url }}">Read the blog</a></p>

<h2 id="use">Use the repository</h2>
The apt of the phone speaks TLS 1.0 only, so two packages are installed by hand first: <code>curl</code> and <code>apt-transport-curl</code>
(download both from the <a href="https://n900-resurrection.github.io/n900-repository/pool/main/">pool</a>, copy them to the phone, install with <code>dpkg -i</code> as root). Then:

```
echo "deb https://n900-resurrection.github.io/n900-repository fremantle main" > /etc/apt/sources.list.d/n900.list
apt-get update
apt-get install htop3
```

The repository is not signed yet, so apt asks for `--force-yes`. Full instructions are in the [repository README](https://github.com/n900-resurrection/n900-repository).

<h2>Latest from the blog</h2>
<ul class="post-list">
{% for post in site.posts limit: 5 %}
  <li><span class="date">{{ post.date | date: "%-d %b %Y" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
