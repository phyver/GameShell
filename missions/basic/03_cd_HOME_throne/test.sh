#!/bin/sh

. history_start.sh

# add dummy commands to avoid error messages
add_cmd dummy1
add_cmd dummy2
add_cmd dummy3

cd
gsh assert check false


add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
cd
gsh assert check false

add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd ../../../
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
cd
gsh assert check false


cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd cd
add_cmd cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
add_cmd gsh check
gsh assert check true

. history_clean.sh
