#!/bin/sh

. alt_history_start.sh

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh check

. alt_history_stop.sh
