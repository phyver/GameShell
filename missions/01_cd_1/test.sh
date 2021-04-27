gash assert_check false

cd ..
gash assert_check false

cd
gash assert_check false

cd "$(eval_gettext "\$GASH_HOME/Castle/Dungeon/First_floor/Second_floor/Top_of_the_dungeon")"
gash assert_check true

cd "$(eval_gettext "\$GASH_HOME/Castle/Dungeon/First_floor/Second_floor/Top_of_the_dungeon")/.."
gash assert_check false


