#!/usr/bin/env sh

spellbook=$(eval_gettext "\$GSH_HOME/Castle/Lab/")/$(eval_gettext "Spellbook")
mkdir -p "$spellbook"
cd "$spellbook"
unset spellbook
git init
gsh check
