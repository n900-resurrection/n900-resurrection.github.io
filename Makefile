# Makefile: local build of the web site of N900 Resurrection (Jekyll with the theme from ../maemo-theme, or the remote theme with REMOTE=1).
#   make            help          make serve       local server with live reload (http://127.0.0.1:4000, PORT=... to change)
#   make build      build into _site/ (with drafts: make build DRAFTS=1)
# Paths: THEME = the checkout of maemo-theme, N900_REPO = the main repository (nokia-n900-apps) with scripts/mksite.py and n900-repository/.

THEME    ?= ../maemo-theme
N900_REPO?= ../N900
DRAFTS   ?=
REMOTE   ?=
PORT     ?= 4000

RED    := $(shell printf '\033[0;31m')
GREEN  := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
CYAN   := $(shell printf '\033[0;36m')
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')

# local theme by default: the theme gem comes from THEME; _config.local.yml is _config.yml without the remote theme (a key cannot be removed by a second config file)
ifeq ($(REMOTE),)
  export THEME_PATH := $(THEME)
  CONFIG := --config _config.local.yml,_config.dev.yml
  LOCALCFG := _config.local.yml
else
  CONFIG :=
endif
export PAGES_REPO_NWO ?= n900-resurrection/n900-resurrection.github.io
JEKYLL := bundle exec jekyll
FLAGS  := $(CONFIG) $(if $(DRAFTS),--drafts)

_config.local.yml: _config.yml
	@sed '/^remote_theme:/d; /jekyll-remote-theme/d' _config.yml > $@

.PHONY: help install install-system deps catalogue update build serve doctor new-post publish check clean
.DEFAULT_GOAL := help

help:
	@printf "$(CYAN)Targets:$(RESET)\n"
	@printf "  $(BOLD)install$(RESET)     - install the Ruby gems (bundle install); build, serve and doctor do it by themselves when gems are missing\n"
	@printf "  $(BOLD)install-system$(RESET) - install Ruby, bundler and build tools with apt (sudo), once per computer\n"
	@printf "  $(BOLD)update$(RESET)      - everything before a publication: regenerate the catalogue, build, check the links, show what changed (commit and push by hand)\n"
	@printf "  $(BOLD)publish$(RESET)     - move a draft to _posts/ with today's date: make publish DRAFT=_drafts/2026-11-14-title.md\n"
	@printf "  $(BOLD)catalogue$(RESET)   - regenerate the package catalogue from the pool of the repository ($(N900_REPO)); run after make repo\n"
	@printf "  $(BOLD)build$(RESET)       - build the site into _site/ (DRAFTS=1 includes _drafts/, but Jekyll 3 then cannot resolve post_url links; REMOTE=1 uses the theme from GitHub)\n"
	@printf "  $(BOLD)serve$(RESET)       - local server with live reload at http://127.0.0.1:$(PORT) (PORT=4001 when 4000 is taken; DRAFTS=1 adds _drafts/)\n"
	@printf "  $(BOLD)doctor$(RESET)      - Jekyll doctor: check the site for problems\n"
	@printf "  $(BOLD)new-post$(RESET)    - a new draft: make new-post TITLE=\"Title of the post\"\n"
	@printf "  $(BOLD)check$(RESET)       - links to local pages in _site/ that lead nowhere (after make build)\n"
	@printf "  $(BOLD)clean$(RESET)       - remove _site/ and caches\n"
	@printf "Theme: $(THEME) (cloned from GitHub when missing)   Main repository: $(N900_REPO)\n"

install-system:
	@printf "$(CYAN)Installing Ruby and the tools Jekyll needs (apt, sudo)...$(RESET)\n"
	sudo apt-get install -y ruby-full ruby-bundler build-essential zlib1g-dev git python3

# the theme is cloned when its folder is missing; the gems are installed when bundle check says some are missing
$(THEME):
	@printf "$(CYAN)Cloning the theme into $(THEME) ...$(RESET)\n"
	git clone https://github.com/n900-resurrection/maemo-theme.git $(THEME)

deps: $(if $(REMOTE),,$(THEME))
	@command -v bundle >/dev/null || { printf "$(RED)bundler is not installed: make install-system (or install ruby and bundler yourself)$(RESET)\n"; exit 1; }
	@bundle check >/dev/null 2>&1 || { printf "$(YELLOW)Ruby gems are missing, installing them ...$(RESET)\n"; $(MAKE) --no-print-directory install; }

install:
	@printf "$(CYAN)Installing Ruby gems...$(RESET)\n"
	bundle config set --local path vendor/bundle
	bundle install

catalogue:
	@test -f $(N900_REPO)/scripts/mksite.py || { printf "$(RED)the main repository is not at $(N900_REPO): make catalogue N900_REPO=/path/to/nokia-n900-apps$(RESET)\n"; exit 1; }
	@printf "$(CYAN)Generating the package catalogue from $(N900_REPO)/n900-repository/pool ...$(RESET)\n"
	python3 $(N900_REPO)/scripts/mksite.py --pool $(N900_REPO)/n900-repository/pool --icons $(N900_REPO)/icons/packages --web-icons $(N900_REPO)/icons/web --apps $(N900_REPO)/apps --site .
	@printf "$(YELLOW)Review with git diff and commit: _data/packages.json, packages/, assets/packages/icons/$(RESET)\n"

# the usual update after make repo in the main repository: catalogue, build, check; the commit and the push stay with you
update: catalogue check
	@printf "\n$(CYAN)What changed:$(RESET)\n"
	@git status --short | head -30
	@git diff --stat | tail -3
	@printf "\n$(GREEN)Looks right?$(RESET) Commit and publish with:\n  git add -A && git commit -m \"Catalogue update\" && git push\n"

publish:
	@./publish.sh "$(DRAFT)"

build: deps $(LOCALCFG)
	@printf "$(CYAN)Building the site into _site/ ...$(RESET)\n"
	$(JEKYLL) build $(FLAGS)

serve: deps $(LOCALCFG)
	@printf "$(CYAN)Serving the site (live reload) ...$(RESET)\n"
	$(JEKYLL) serve --livereload --port $(PORT) $(FLAGS)

doctor: deps $(LOCALCFG)
	@printf "$(CYAN)Running Jekyll doctor...$(RESET)\n"
	$(JEKYLL) doctor $(CONFIG)

new-post:
	@./newpost.sh "$(TITLE)"

check: build
	@printf "$(CYAN)Checking links to local pages in _site/ ...$(RESET)\n"
	@python3 -I scripts/linkcheck.py _site

clean:
	@printf "$(CYAN)Cleaning _site/ and caches...$(RESET)\n"
	rm -rf _site .jekyll-cache .sass-cache _config.local.yml
