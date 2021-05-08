
cp "$(eval_gettext '$GSH_HOME/Castle/Entrance')"/$(gettext "standard")_? "$GSH_CHEST"
gsh assert check true

mv "$(eval_gettext '$GSH_HOME/Castle/Entrance')"/$(gettext "standard")_? "$GSH_CHEST"
gsh assert check false

gsh assert check false
