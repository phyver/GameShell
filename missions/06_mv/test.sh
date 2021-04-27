mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(gettext "coin")_"2 "$GASH_CHEST"
gash assert check false

mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(gettext "coin")_"{1,3} "$GASH_CHEST"
gash assert check false

mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/$(gettext "coin")_"? "$GASH_CHEST"
gash assert check true
