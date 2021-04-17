# TODO: generate new po file from template with msgen

LANG=$(wildcard i18n/*.po)

all: $(LANG)

$(LANG):%.po: i18n/template.pot
	msgmerge --update --no-wrap $@ i18n/template.pot

i18n/template.pot: *.sh
	mkdir -p i18n/
	touch i18n/template.pot
	xgettext --from-code=UTF-8 --omit-header --no-wrap --join-existing --output i18n/template.pot *.sh
	msgen --no-wrap --output i18n/template.pot i18n/template.pot

new: i18n/template.pot
	@read -p "language code: " lang; \
		[ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
		echo "file i18n/$$lang.po created"; \
		msgen --no-wrap --output i18n/$$lang.po i18n/template.pot; \
		touch --date="2000-01-01" "i18n/$$lang.po"

clean:
	rm i18n/*~

cleaner: clean
	find . -maxdepth 1 -type f -name "_*" -print0 | xargs -0 --open-tty rm -i

.PHONY: clean cleaner translation new

