MANPATH = ../../../man
HELPPATH = ../..

LANGS = en fr
MANPAGES = $(addsuffix .1, $(LANGS))
HELPFILES = $(addsuffix .help, $(LANGS))
FULLHELPFILES = $(addsuffix .full_help, $(LANGS))

clean = sed -f ../clean.sed
include_files = awk -f ../include_files.awk

all: $(MANPAGES) $(HELPFILES) $(FULLHELPFILES)

install: all
	@mkdir -p $(MANPATH)/man1/
	for file in ??.1; do mkdir -p $(MANPATH)/$${file%.1}/man1/; cp "$$file" "$(MANPATH)/$${file%.1}/man1/gsh.1"; done
	mv $(MANPATH)/en/man1/* $(MANPATH)/man1/
	rmdir $(MANPATH)/en/man1/
	for file in ??.full_help; do cp "$$file" "$(HELPPATH)/gsh-full-help/$${file%.full_help}.txt"; done
	for file in ??.help; do cp "$$file" "$(HELPPATH)/gsh-help/$${file%.help}.txt"; done

%.txt: %/*.txt
	$(include_files) $*/man_gsh.txt > $@

# NOTE: english man page should go to the default man/man1 directory
en.1: en.txt
	a2x --doctype manpage --format manpage $<
	mv gsh.1 $@

# NOTE: translated man pages should go to the man/LANGUAGE/man1 directory
%.1: %.txt
	a2x --doctype manpage --format manpage $<
	mv gsh.1 $@

%.full_help: %/*.txt
	$(include_files) $*/gsh_full_help.txt | $(clean) > $@

%.help: %/*.txt
	$(include_files) $*/gsh_help.txt | $(clean) > $@

clean:
	rm -f *.1 *.html *.txt *.help *.full_help

.PHONY: clean all
