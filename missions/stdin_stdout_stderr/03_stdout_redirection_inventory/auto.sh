#!/usr/bin/env sh

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"
ls "$(gettext "grimoire")"_* > "$(gettext "Drawer")/$(gettext "inventory.txt")"
gsh check
