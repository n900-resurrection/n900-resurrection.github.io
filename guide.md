---
layout: page
title: Guide
permalink: /guide/
---
<p class="lead">What the Nokia N900 is, what it can do, how to use it and how to get modern software onto it. The blog tells the story; these pages stay in a fixed order and are kept up to date.</p>
<ol class="guide-list">
{% assign pages = site.guide | sort: "order" %}
{% for p in pages %}
  <li><a href="{{ p.url | relative_url }}">{{ p.title }}</a>{% if p.summary %}<br><span class="meta">{{ p.summary }}</span>{% endif %}</li>
{% endfor %}
</ol>
