#!/usr/bin/env sh

dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')

if [ "$(readlink-f "$(pwd)" 2>/dev/null)" = "$(readlink-f "$dir" 2>/dev/null)" ]
then
    unset dir
    true
else
    echo "$(gettext "You are not in the King's quarter!")"
    unset dir
    false
fi
