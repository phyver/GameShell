#!/bin/bash

cp "$(eval_gettext '$MISSION_DIR/ingredients/en.txt')" "$(eval_gettext '$GASH_HOME/Montain/Cavern')/$(gettext "potion_ingredients")" 
