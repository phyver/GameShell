#!/usr/bin/env sh

command="$(gettext 'flarigo')"
sed "s/\\\$command/$command/g" "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset command
