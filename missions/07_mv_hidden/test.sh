mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_2_"* "$GASH_CHEST"
gash assert check false

mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_"{1,3}_* "$GASH_CHEST"
gash assert check false

cp "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_1"* "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_1_truc"
gash assert check false

cp "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_1"* "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_1_truc"
mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_"* "$GASH_CHEST"
gash assert check false

cp "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_"* "$GASH_CHEST"
gash assert check false

mv "$(eval_gettext '$GASH_HOME/Castle/Cellar')/.$(gettext "coin")_"* "$GASH_CHEST"
gash assert check true
