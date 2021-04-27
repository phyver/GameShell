cd
gash assert check false

cd "$(eval_gettext '$GASH_HOME/Castle/Cellar')"
gash assert check false

cd "$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext ".Long*Corridor*")" -type d)"
gash assert check true
