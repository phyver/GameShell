LANGUAGES=$(wildcard i18n/*.po)
LANGUAGES:=$(filter-out i18n/en.po, $(LANGUAGES))
SH_FILES= start.sh  scripts/* lib/gsh.sh lib/bashrc lib/zshrc lib/gshrc
AWK_FILES=scripts/_gsh_stat.awk
OTHER_FILES=

SORT=--sort-output
OPTIONS=--indent --no-wrap --no-location

all: i18n/en.po $(LANGUAGES)

add-locations: SORT=--add-location --sort-by-file
add-locations: all

i18n/en.po: i18n/template.pot FORCE
	@echo "msgen $@"
	@msgen $(OPTIONS) $(SORT) i18n/template.pot --output=$@
	@echo "# AUTOMATICALLY GENERATED -- DO NOT EDIT" | cat - $@ > $@~
	@mv $@~ $@

$(LANGUAGES):%.po: i18n/template.pot FORCE
	@echo "msgmerge $@"
	@msgmerge --quiet --update $(OPTIONS) $(SORT) $@ i18n/template.pot

i18n/template.pot: $(SH_FILES) $(OTHER_FILES) FORCE
	@mkdir -p i18n/
	@echo "generating i18n/template.pot"
	xgettext -L shell --from-code=UTF-8 --omit-header $(OPTIONS) $(SORT) --join-existing --output i18n/template.pot $(SH_FILES) $(OTHER_FILES)
	@xgettext -L awk -k_ -k_n:1,2 --from-code=UTF-8 --omit-header $(OPTIONS) $(SORT) --join-existing --output i18n/template.pot $(AWK_FILES)

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgcat $(OPTIONS) --output i18n/$$lang.po i18n/template.pot

## check that the auto.sh scripts work as expected
check: clean
	./utils/archive.sh -at -N "game shell (1)"
	./"game shell (1).sh" -q -c 'gsh systemconfig; for _ in $$(seq 42); do gsh auto --abort < <(echo gsh); done; gsh stat'

## check that the auto.sh scripts work as expected, in verbose mode
check-verbose: clean
	./utils/archive.sh -at -N "game shell (1)"
	./"game shell (1).sh" -Dq -c 'gsh systemconfig; for _ in $$(seq 42); do gsh auto --abort; done; gsh stat'

## run all the test.sh and auto.sh scripts
tests-bash: clean
	./utils/archive.sh -at -N "game shell (1)"
	./"game shell (1).sh" -Bdq -c 'gsh systemconfig; for _ in $$(seq 42); do gsh goal|cat; gsh test --abort; gsh auto --abort; done; gsh stat'

## run all the test.sh and auto.sh scripts
tests-zsh: clean
	./utils/archive.sh -at -N "game shell (1)"
	./"game shell (1).sh" -Zdq -c 'gsh systemconfig; for _ in $$(seq 42); do gsh goal|cat; gsh test --abort; gsh auto --abort; done; gsh stat'

clean:
	rm -rf i18n/*~ locale gameshell.tgz gameshell.sh gameshell-save*.sh scripts/boxes-data.awk
	rm -rf .bin .config .sbin .var .tmp World
	rm -rf "game shell"*

.PHONY: clean new FORCE
