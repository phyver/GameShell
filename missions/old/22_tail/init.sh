#!/bin/bash

cp "$(eval_gettext '$MISSION_DIR/ingredients/en.txt')" "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "potion_ingredients")" 
