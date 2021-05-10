#!/bin/bash

TEXTDOMAIN=$(textdomainname "$MISSION_DIR")
sed "s/export TEXTDOMAIN=.*/export TEXTDOMAIN=$TEXTDOMAIN/" "$MISSION_DIR/spell.sh" > "$GSH_VAR/$(gettext "spell")"
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" &
echo $! > "$GSH_VAR/spell.pids"
disown
