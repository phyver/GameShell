#!/bin/bash

echo "$(gettext "What's the key that will make Merlin's chest to appear?")"
read -er dcode

if [ "$dcode" = "$(cat "$GSH_VAR/secret_key")" ]
then
    unset dcode
    mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Cellar/Merlin_s_Chest')"
    cp "$(eval_gettext '$MISSION_DIR/secret_recipe/en.txt')" "$(eval_gettext '$GSH_HOME/Castle/Cellar/Merlin_s_Chest/secret_recipe')"
    true
else
    echo "$(gettext "That's not the secret key.")"
    unset dcode
    false
fi

