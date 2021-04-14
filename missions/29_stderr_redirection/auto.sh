cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Library/Merlin_s_office')"

# les commandes ne sont pas dans l'historique, il faut les y ajouter à la main !
history -s 'grep -il "pq" "$(gettext "grimoire")"_* 2> /dev/null'
history -s gash check

grep -il "pq" "$(gettext "grimoire")"_* 2> /dev/null
gash check

history -d -2--1

