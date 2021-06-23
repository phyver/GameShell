#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
add_cmd -s cd
add_cmd -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd -s gsh check

gsh check

. history_clean.sh
