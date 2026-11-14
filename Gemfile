source "https://rubygems.org"
# GitHub Pages builds the site with its own set of gems; this Gemfile is for building it locally (make build / make serve).
gem "github-pages", group: :jekyll_plugins
gem "webrick"                                   # `jekyll serve` on Ruby 3
# THEME_PATH=../maemo-theme: the theme from a local checkout instead of the remote theme (the Makefile sets it)
gem "maemo-theme", path: ENV["THEME_PATH"] if ENV["THEME_PATH"]
