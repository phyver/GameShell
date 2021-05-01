gash assert_check false

cd ..
gash assert_check false

cd
gash assert_check false

cd "$(eval_gettext "\$GASH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")"
gash assert_check true

cd "$(eval_gettext "\$GASH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")/.."
gash assert_check false


