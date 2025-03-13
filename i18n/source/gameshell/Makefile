MANPATH = ../../../man
HELPPATH = ../..

LANGS = en
MANPAGES = $(addsuffix .1, $(LANGS))

clean = sed -f ../clean.sed
include_files = awk -f ../include_files.awk

all: $(MANPAGES)

install: all
	@mkdir -p $(MANPATH)/man1/
	for file in ??.1; do mkdir -p $(MANPATH)/$${file%.1}/man1/; cp "$$file" "$(MANPATH)/$${file%.1}/man1/gameshell.sh.1"; done
	mv $(MANPATH)/en/man1/* $(MANPATH)/man1/
	rmdir $(MANPATH)/en/man1/

%.txt: %/*.txt
	$(include_files) $*/man_gameshell.txt > $@

# NOTE: english man page should go to the default man/man1 directory
en.1: en.txt
	a2x --doctype manpage --format manpage $<
	@mkdir -p $(MANPATH)/man1/
	mv gameshell.sh.1 $@

# NOTE: translated man pages should go to the man/LANGUAGE/man1 directory
%.1: %.txt
	a2x --doctype manpage --format manpage $<
	@mkdir -p $(MANPATH)/$*/man1/
	mv gameshell.sh.1 $@

clean:
	rm -f *.1 *.html *.txt

.PHONY: clean all
