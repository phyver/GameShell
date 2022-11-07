#!/usr/bin/env sh

dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
chmod +r "$dir/.$(gettext "secret_note")"
gsh assert check true < "$dir/.$(gettext "secret_note")"

dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
gsh assert check false < "$dir/$(gettext "note")"

unset dir
