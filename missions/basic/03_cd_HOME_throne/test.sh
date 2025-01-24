#!/usr/bin/env sh

. alt_history_start.sh

# add dummy commands to avoid error messages
add_cmd dummy1
add_cmd dummy2
add_cmd dummy3

# OK
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh assert check true

# OK
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd  \~
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh assert check true

# not OK, using cd ../.. shouldn't work
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd ../..
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh assert check false

# commands OK, but not in appropriate directory
cd
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh assert check false

# OK, with several gsh commands in between actual commands
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd gsh goal
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh goal
add_cmd gsh check
gsh assert check true

# OK, with aliases for gsh commands
alias gc="gsh check"
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gc
gsh assert check true
unalias gc

# OK, with nested aliases for gsh commands
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
