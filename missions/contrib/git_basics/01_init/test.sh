#!/usr/bin/env sh

spellbook=$(eval_gettext "Spellbook")
lab=$(eval_gettext "\$GSH_HOME/Castle/Lab/")

cd
gsh assert check false

mkdir "$spellbook"
gsh assert check false

mkdir "$spellbook"
cd "$spellbook"
gsh assert check false

mkdir "$lab/$spellbook"
cd "$lab/$spellbook"
gsh assert check false

git init
gsh assert check true

unset lab spellbook
