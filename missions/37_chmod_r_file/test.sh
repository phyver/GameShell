#!/bin/bash

dir=$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
chmod +r "$dir/.$(gettext "secret_note")"
gash assert check true < "$dir/.$(gettext "secret_note")"

dir=$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
gash assert check false < "$dir/$(gettext "note")"

unset dir
