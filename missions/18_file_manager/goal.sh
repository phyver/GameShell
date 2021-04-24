#!/bin/bash

export maze="$(find "$(eval_gettext '$GASH_HOME/Castle/Cellar')" -name "$(gettext "maze")" -type d)"

envsubst '$maze' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"

unset maze
