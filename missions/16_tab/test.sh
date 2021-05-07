cd
gsh assert check false

cd "$(eval_gettext '$GSH_HOME/Castle/Cellar')"
gsh assert check false

cd "$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -name "$(gettext ".Long*Corridor*")" -type d)"
gsh assert check true
