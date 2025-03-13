all: gsh-commands gameshell

gsh-commands:
	make -C ./gsh-commands

gameshell:
	make -C ./gameshell

install: all
	make -C ./gameshell install
	make -C ./gsh-commands install


.PHONY: all gsh-commands gameshell

