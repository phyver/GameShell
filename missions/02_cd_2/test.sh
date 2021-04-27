cd
gash assert_check false

cd "$(eval_gettext "\$GASH_HOME/Castle/Cellar")"
gash assert_check true

cd "$(eval_gettext "\$GASH_HOME/Castle/Cellar")/.."
gash assert_check false

cd
gash assert_check false


