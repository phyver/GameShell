cp "$(eval_gettext '$GASH_HOME/Castle/Entrance')"/*_$(gettext "ornament")_* "$GASH_CHEST"
gash assert check true

mv "$(eval_gettext '$GASH_HOME/Castle/Entrance')"/* "$GASH_CHEST"
gash assert check false

mv "$(eval_gettext '$GASH_HOME/Castle/Entrance')"/*_$(gettext "ornament")_* "$GASH_CHEST"
gash assert check false

cp "$(eval_gettext '$GASH_HOME/Castle/Entrance')"/*_$(gettext "ornament")_* "$GASH_CHEST"
gash assert check true

