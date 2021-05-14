export maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
envsubst '$maze' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset maze
