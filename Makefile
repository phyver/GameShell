LANG=$(wildcard i18n/*.po)
LANG:=$(filter-out i18n/en.po, $(LANG))
SH_FILES= start.sh bin/archive.sh lib/gameshell.sh lib/common.sh lib/*_common.sh
OTHER_FILES=

SORT=--sort-output
OPTIONS=--indent --no-wrap --no-location

all: i18n/en.po $(LANG)

add-locations: SORT=--add-location --sort-by-file
add-locations: all

i18n/en.po: i18n/template.pot FORCE
	@echo "msgen $@"
	@msgen $(OPTIONS) $(SORT) i18n/template.pot --output=$@

$(LANG):%.po: i18n/template.pot FORCE
	@echo "msgmerge $@"
	@msgmerge --quiet --update $(OPTIONS) $(SORT) $@ i18n/template.pot

i18n/template.pot: $(SH_FILES) $(OTHER_FILES) FORCE
	@mkdir -p i18n/
	@echo "generating i18n/template.pot"
	@xgettext --from-code=UTF-8 --omit-header $(OPTIONS) $(SORT) --join-existing --output i18n/template.pot $(SH_FILES) $(OTHER_FILES)

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgcat $(OPTIONS) --output i18n/$$lang.po i18n/template.pot

clean:
	rm -rf i18n/*~ locale GameShell.tgz GameShell.sh GameShell-save.sh
	rm -rf .bashrc .bin .config .var World

.PHONY: clean new FORCE
