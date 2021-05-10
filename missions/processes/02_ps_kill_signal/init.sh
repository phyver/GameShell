#!/bin/bash

if [ -x /usr/bin/python3 ]
then
    cp "$MISSION_DIR/spell.py" "$GSH_VAR/$(gettext "spell")"
else
    cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
fi
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" "$TEXTDOMAIN" &
echo $! > "$GSH_VAR/spell.pids"
disown
