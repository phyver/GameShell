gash assert check false

rm -f "$(eval_gettext '$GASH_HOME/Castle/Cellar')"/.??*
gash assert check false

rm -f "$(eval_gettext '$GASH_HOME/Castle/Cellar')"/.*_"$(gettext "spider")"
gash assert check true

