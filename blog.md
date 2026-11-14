---
layout: page
title: Blog
permalink: /blog/
---
<ul class="post-list">
{% for post in site.posts %}
  <li><span class="date">{{ post.date | date: "%-d %b %Y" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
