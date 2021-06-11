#!/bin/bash
# ``history`` command is not in POSIX

cd
gsh assert check false


history -s cd
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check
cd
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-2))
history -d $((n-2))
history -d $((n-2))
unset n

history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s cd ../../../
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check
cd
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-3))
history -d $((n-3))
history -d $((n-3))
history -d $((n-3))
unset n


cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s cd
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-2))
history -d $((n-2))
history -d $((n-2))
unset n
