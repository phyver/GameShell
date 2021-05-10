#!/bin/bash

cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" &
echo $! > "$GSH_VAR"/spell.pid
disown
