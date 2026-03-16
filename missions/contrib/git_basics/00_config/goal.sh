#!/usr/bin/env sh

cat "$(eval_gettext '$MISSION_DIR/goal/en.txt')"

if [ -f "$REAL_HOME/.gitconfig" ]
then
    sed -e "s/\\\$REAL_USER/$(whoami)/g" "$(eval_gettext '$MISSION_DIR/goal/en-gitinit.txt')"
fi
