#!/bin/bash

dir=$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
chmod +r "$dir/.$(gettext "secret_note")"
gash check < "$dir/.$(gettext "secret_note")"
