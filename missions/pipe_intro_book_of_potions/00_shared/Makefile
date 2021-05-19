SH_FILES=$(wildcard *.sh)
EXCEPTIONS=
OTHER_FILES=

LANG=$(wildcard i18n/*.po)
LANG:=$(filter-out i18n/en.po, $(LANG))
SH_FILES:=$(filter-out $(EXCEPTIONS), $(SH_FILES))
SORT=--sort-output
OPTIONS=--indent --no-wrap --no-location

all: i18n/en.po $(LANG)

add-locations: SORT=--add-location --sort-by-file
add-locations: all

i18n/en.po: i18n/template.pot FORCE
	@echo "msgen $@"
	@msgen $(OPTIONS) $(SORT) i18n/template.pot --output=$@
	@sed -i -e '1s/^/'"# AUTOMATICALLY GENERATED -- DO NOT EDIT\n/" $@

$(LANG):%.po: i18n/template.pot FORCE
	@echo "msgmerge $@"
	@msgmerge --update $(OPTIONS) $(SORT) $@ i18n/template.pot

i18n/template.pot: $(SH_FILES) $(OTHER_FILES) FORCE
	@mkdir -p i18n/
	@echo "generating i18n/template.pot"
	@xgettext --from-code=UTF-8 --omit-header $(OPTIONS) $(SORT) --join-existing --output i18n/template.pot $(SH_FILES) $(OTHER_FILES)
	@echo "done"

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgcat $(OPTIONS) --output i18n/$$lang.po i18n/template.pot

clean:
	rm -f i18n/*~

.PHONY: all clean new FORCE
