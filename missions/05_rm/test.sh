gash assert check false

rm "$(eval_gettext '$GASH_HOME/Castle/Cellar')"/*
gash assert check false

rm "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(gettext "spider")"?
gash assert check true

rm "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(gettext "spider")"?
rm "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(gettext "salamander")"1
gash assert check false
