#!/usr/bin/env sh

cp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')/$(head -n1 "$GSH_TMP/painting")" "$GSH_CHEST"
gsh assert check true

gsh assert check false

cp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')/$(gettext "painting")_"* "$GSH_CHEST"
gsh assert check false

gsh assert '[ "$(find "$GSH_HOME" -name "'$(gettext "painting")'_*" | wc -l)" -eq 3 ]'

cp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')/$(head -n1 "$GSH_TMP/painting")" "$GSH_CHEST"
gsh assert check true
