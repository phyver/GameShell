goal=$(CANONICAL_PATH "$(eval_gettext "\$GASH_HOME/Castle/Dungeon/First_floor/Second_floor/Top_of_the_dungeon")")
current=$(CANONICAL_PATH "$PWD")

if [ "$goal" = "$current" ]
then
    unset goal current
    true
else
    echo "$(gettext "You are not at the top of the dungeon!")"
    echo "$(gettext "You will start over from the starting point of the mission.")"
    cd "$GASH_HOME"
    unset goal current
    false
fi

