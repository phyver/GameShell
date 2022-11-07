#!/usr/bin/env sh

maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
# NOTE: POSIX sed doesn't support using another character than '/' in "s/.../.../"
maze=$(echo "$maze" | sed 's/\//\\\//g')
sed "s/\\\$maze/$maze/g" "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset maze
