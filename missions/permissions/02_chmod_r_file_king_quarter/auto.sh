#!/usr/bin/env sh

dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
chmod +r "$dir/.$(gettext "secret_note")"
gsh check < "$dir/.$(gettext "secret_note")"
unset dir
