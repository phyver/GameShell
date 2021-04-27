
cp "$(eval_gettext '$GASH_HOME/Castle/Entrance')"/$(gettext "standard")_? "$GASH_CHEST"
gash assert check true

mv "$(eval_gettext '$GASH_HOME/Castle/Entrance')"/$(gettext "standard")_? "$GASH_CHEST"
gash assert check false

gash assert check false
