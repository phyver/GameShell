#!/usr/bin/env sh

gsh assert check false

cd ..
gsh assert check false

cd
gsh assert check false

cd "$(eval_gettext "\$GSH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")"
gsh assert check true

cd "$(eval_gettext "\$GSH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")/.."
gsh assert check false
