LANGUAGES=$(wildcard i18n/*.po)
LANGUAGES:=$(filter-out i18n/en.po, $(LANGUAGES))
SH_FILES= start.sh lib/gsh.sh lib/profile.sh bin/*
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
	@xgettext -L shell --from-code=UTF-8 --omit-header $(OPTIONS) $(SORT) --join-existing --output i18n/template.pot $(SH_FILES) $(OTHER_FILES)

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgcat $(OPTIONS) --output i18n/$$lang.po i18n/template.pot

## check that the auto.sh scripts work as expected
check: clean
	./utils/archive.sh -at -N "game shell (1)"
	echo 'gsh systemconfig; for _ in $$(seq 42); do gsh auto --abort; done; gsh index|cat' | ./"game shell (1).sh" -Rdq

## check that the auto.sh scripts work as expected, in verbose mode
check-verbose: clean
	./utils/archive.sh -at -N "game shell (1)"
	echo 'gsh systemconfig; for _ in $$(seq 42); do gsh auto --abort; done; gsh index|cat' | ./"game shell (1).sh" -RDq

## run all the test.sh and auto.sh scripts
tests: clean
	./utils/archive.sh -at -N "game shell (1)"
	echo 'gsh systemconfig; for _ in $$(seq 42); do gsh test --abort; gsh auto --abort; done; gsh index|cat' | ./"game shell (1).sh" -Rdq

## run all the test.sh and auto.sh scripts, in verbose mode
tests-verbose: clean
	./utils/archive.sh -at -N "game shell (1)"
	echo 'gsh systemconfig; for _ in $$(seq 42); do gsh test --abort; gsh auto --abort; done; gsh index|cat' | ./"game shell (1).sh" -RDq

clean:
	rm -rf i18n/*~ locale gameshell.tgz gameshell.sh gameshell-save.sh bin/boxes-data.awk
	rm -rf .bashrc .bin .config .sbin .var World
	rm -rf "game shell"*

.PHONY: clean new FORCE
