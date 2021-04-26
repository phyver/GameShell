LANG=$(wildcard i18n/*.po)
SH_FILES=$(wildcard *.sh)
OTHER_FILES=

ADD_LOCATION=

all: $(LANG)

add-locations: ADD_LOCATION=--add-location --sort-by-file
add-locations: all

$(LANG):%.po: i18n/template.pot FORCE
	msgmerge --quiet --update --no-wrap --no-location $(ADD_LOCATION) $@ i18n/template.pot

i18n/template.pot: $(SH_FILES) $(OTHER_FILES) FORCE
	@mkdir -p i18n/
	@touch i18n/template.pot
	xgettext --from-code=UTF-8 --omit-header --no-wrap --no-location $(ADD_LOCATION) --join-existing --output i18n/template.pot $(SH_FILES) $(OTHER_FILES)

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgen --no-wrap --output i18n/$$lang.po i18n/template.pot; \
		touch --date="2000-01-01" "i18n/$$lang.po"

clean:
	rm -f i18n/*~

cleaner: clean
	find . -maxdepth 1 -type f -name "_*" -print0 | xargs -0 --open-tty rm -i

.PHONY: all clean cleaner new FORCE
