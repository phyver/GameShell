mv "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_2_"* "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"{1,3}_* "$GSH_CHEST"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_1"* "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_1_truc"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_1"* "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_1_truc"
mv "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"* "$GSH_CHEST"
gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"* "$GSH_CHEST"
gsh assert check false

mv "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"* "$GSH_CHEST"
gsh assert check true
