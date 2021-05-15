#!/usr/bin/env bash

dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')

if [ "$(REALPATH "$(pwd)")" = "$(REALPATH "$dir")" ]
then
    unset dir
    true
else
    echo "$(gettext "You are not in the King's quarter!")"
    unset dir
    false
fi
