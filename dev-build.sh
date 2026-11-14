#!/bin/bash
# Build the site locally with the theme from ../maemo-theme (without the network: remote_theme is replaced by a copy of the theme files).
# Usage: ./dev-build.sh [outdir]     needs Jekyll; BUNDLE_GEMFILE may point at any Gemfile with github-pages (default: this one)
set -euo pipefail
cd "$(dirname "$0")"
OUT="${1:-_site}"
THEME="${THEME:-../maemo-theme}"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
rsync -a --exclude _site --exclude .git --exclude vendor ./ "$TMP/"
for d in _layouts _includes assets; do rsync -a "$THEME/$d/" "$TMP/$d/"; done
sed -i '/^remote_theme:/d; /jekyll-remote-theme/d' "$TMP/_config.yml"
PAGES_REPO_NWO=${PAGES_REPO_NWO:-n900-resurrection/n900-resurrection.github.io} bundle exec jekyll build -s "$TMP" -d "$(realpath -m "$OUT")" --config "$TMP/_config.yml"
