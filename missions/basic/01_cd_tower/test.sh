#!/usr/bin/env sh

gsh assert_check false

cd ..
gsh assert_check false

cd
gsh assert_check false

cd "$(eval_gettext "\$GSH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")"
gsh assert_check true

cd "$(eval_gettext "\$GSH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")/.."
gsh assert_check false
