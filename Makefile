
LANG=$(wildcard i18n/*.po)

all: $(LANG)

$(LANG):%.po: i18n/template.pot
	msgmerge --update --no-wrap $@ i18n/template.pot

i18n/template.pot: *.sh
	mkdir -p i18n/
	touch i18n/template.pot
	xgettext --from-code=UTF-8 --omit-header --no-wrap --join-existing --output i18n/template.pot start.sh bin/archive.sh lib/gameshell.sh lib/utils.sh lib/os_aliases.sh
	msgen --no-wrap --output i18n/template.pot i18n/template.pot

new: i18n/template.pot
	@read -p "language code: " lang; \
        [ -e "./i18n/$$lang.po" ] && echo "file i18n/$$lang.po already exists" && exit; \
        echo "file i18n/$$lang.po created"; \
		msgen --no-wrap --output i18n/$$lang.po i18n/template.pot

clean:
	rm -rf i18n/*~ i18n/template.pot locale

.PHONY: clean new translation
