cp "$(eval_gettext '$GSH_HOME/Castle/Entrance')"/*_$(gettext "tapestry")_* "$GSH_CHEST"
gsh assert check true

mv "$(eval_gettext '$GSH_HOME/Castle/Entrance')"/* "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Castle/Entrance')"/*_$(gettext "tapestry")_* "$GSH_CHEST"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Castle/Entrance')"/*_$(gettext "tapestry")_* "$GSH_CHEST"
gsh assert check true

