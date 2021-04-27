#!/bin/bash

goal=$(REALPATH "$(eval_gettext "\$GASH_HOME/Castle/Dungeon/First_floor/Second_floor/Top_of_the_dungeon")")
current=$(REALPATH "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not at the top of the dungeon!")"
    echo "$(gettext "You need to start over from the start.")"
    cd "$GASH_HOME"
    unset goal current
    false
fi
