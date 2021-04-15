cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"
ls "$(gettext "grimoire")"_* > "$(gettext "Drawer")/$(gettext "list.txt")"
gash check
