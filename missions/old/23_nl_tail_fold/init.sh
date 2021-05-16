#!/bin/bash

cp "$(eval_gettext '$MISSION_DIR/recipe/en.txt')" "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "potion_recipe")"

nl "$(eval_gettext '$MISSION_DIR/recipe/en.txt')" | head -n 7 | fold -s -w50 > "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "potion_recipe.start")"

