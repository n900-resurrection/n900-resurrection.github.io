#!/bin/bash
# Create a draft of a blog post in _drafts/: ./newpost.sh "Title of the post"   (make new-post TITLE="...")
# Move it to _posts/ with the date in the file name (YYYY-MM-DD-title.md) when it is ready.
title="${*:-A title}"
slug=$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9]\+/-/g; s/^-//; s/-$//')
mkdir -p _drafts
path="_drafts/$(date +%Y-%m-%d)-${slug}.md"
[ -e "$path" ] && { echo "$path exists already"; exit 1; }
cat > "$path" <<EOF
---
layout: post
title: "$title"
author: elPytel
tags: [n900]
---
EOF
echo "New draft: $path"
