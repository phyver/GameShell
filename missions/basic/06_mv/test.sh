mv "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "coin")_"2 "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "coin")_"{1,3} "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "coin")_"? "$GSH_CHEST"
gsh assert check true
