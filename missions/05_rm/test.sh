gsh assert check false

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')"/*
gsh assert check false

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")"?
gsh assert check true

rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")"?
rm "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "salamander")"1
gsh assert check false
