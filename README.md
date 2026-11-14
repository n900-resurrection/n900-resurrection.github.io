# n900-resurrection.github.io

The web site of the N900 Resurrection project: a blog (English) about bringing the Nokia N900 back, and the catalogue of the packages of the apt repository
(<https://n900-resurrection.github.io/n900-repository>). Jekyll, with the theme [maemo-theme](https://github.com/n900-resurrection/maemo-theme) as a remote theme
(GitHub Pages builds it).

## The catalogue
`_data/packages.json`, `packages/<name>.md` and `assets/packages/icons/*.png` are **generated** from the `.deb` files of the repository (the control file of each package,
including its embedded icon), never edited by hand. After `make repo` in [nokia-n900-apps](https://github.com/n900-resurrection/nokia-n900-apps):

```sh
python3 scripts/mksite.py --pool n900-repository/pool --site ../n900-resurrection.github.io
git -C ../n900-resurrection.github.io add -A && git -C ../n900-resurrection.github.io commit -m "Catalogue update"
```

## Blog
A post is a file `_posts/YYYY-MM-DD-title.md` with the front matter `layout: post`, `title`, `author`, `tags`.

## Local build
`./dev-build.sh [outdir]` builds the site with the theme from `../maemo-theme` (no network; Jekyll with the `github-pages` gem, `BUNDLE_GEMFILE` can point at any Gemfile that has it).
Serve the output directory with `python3 -m http.server`.
