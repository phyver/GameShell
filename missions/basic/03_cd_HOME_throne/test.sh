#!/usr/bin/env sh

. alt_history_start.sh

# add dummy commands to avoid error messages
add_cmd dummy1
add_cmd dummy2
add_cmd dummy3

cd
add_cmd gsh check
gsh assert check false

add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
cd
add_cmd gsh check
gsh assert check false

add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd ../../../
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
cd
add_cmd gsh check
gsh assert check false

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh assert check true

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd gsh goal
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh goal
add_cmd gsh check
gsh assert check true

alias gc="gsh check"
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gc
gsh assert check true
unalias gc

alias check="gsh check"
alias gc=check
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gc
gsh assert check true
unalias check
unalias gc

. alt_history_stop.sh
