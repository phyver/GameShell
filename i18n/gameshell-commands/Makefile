all: en.1 en.help en.HELP

%.txt: %/*.txt
	awk -f make_man.awk $*/man_gsh.txt > $@

%.1: %.txt
	a2x --doctype manpage --format manpage $<
	[ -L ../../man/en ] || ln -sf ./ ../../man/en
	cp gsh.1 ../../man/man1/
	mv gsh.1 $@

%.HELP: %/*.txt
	awk -f make_man.awk $*/gsh_HELP.txt | sed -f clean.sed > $@
	cp $@ ../gameshell-full-help/$*.txt

%.help: %/*.txt
	awk -f make_man.awk $*/gsh_help.txt | sed -f clean.sed > $@
	cp $@ ../gameshell-help/$*.txt

clean:
	rm -f *.1 *.html *.txt *.help *.HELP ../../man/en

.PHONY: clean all
