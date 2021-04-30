#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Cabin/Chest')"
mkdir -p "$GASH_CHEST"

safe="$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')/$(gettext "Safe")"
mkdir -p "$safe"
chmod 755 "$safe"
chmod -f 644 "$safe/$(gettext "crown")"
k=$(echo -n "000$(($RANDOM % 1000))" | tail -c3)


cat <<EOK>"$safe/$(gettext "crown")"
  _.+._
(^\/^\/^)
 \@*@*@/
 {_${k}_}
EOK

cp "$safe/$(gettext "crown")" "$GASH_MISSION_DATA"/crown

chmod 000 "$safe/$(gettext "crown")"
chmod 000 "$safe"

unset safe k

