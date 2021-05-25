cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"

# les commandes ne sont pas dans l'historique, il faut les y ajouter à la main !
history -s 'grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null'
history -s gsh check

# grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null
gsh check

history -d -2--1

