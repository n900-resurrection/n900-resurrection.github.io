#!/bin/bash
# Publish a draft: ./publish.sh _drafts/2026-11-14-title.md   (make publish DRAFT=...)
# The draft moves to _posts/ and gets today's date in the file name (the date of the publication). The commit and the push stay with you.
set -euo pipefail
draft="${1:-}"
if [ -z "$draft" ] || [ ! -f "$draft" ]; then
    echo "usage: make publish DRAFT=_drafts/<file>.md   (drafts: $(ls _drafts 2>/dev/null | tr '\n' ' '))"
    exit 1
fi
name=$(basename "$draft" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//')
target="_posts/$(date +%Y-%m-%d)-$name"
[ -e "$target" ] && { echo "$target exists already"; exit 1; }
mkdir -p _posts
git mv "$draft" "$target" 2>/dev/null || mv "$draft" "$target"
echo "Published as $target"
slug=${target#_posts/}
echo "A link to it from another post: {% post_url ${slug%.md} %}"
