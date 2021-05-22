#!/bin/bash

goal=$(realpath "$(eval_gettext "\$GSH_HOME/Castle/Main_tower/First_floor/Second_floor/Top_of_the_tower")")
current=$(realpath "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not at the top of the tower!")"
    echo "$(gettext "You need to start over from the start.")"
    cd "$GSH_HOME"
    unset goal current
    false
fi
