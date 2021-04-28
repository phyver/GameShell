export maze="$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')"
envsubst '$maze' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset maze
