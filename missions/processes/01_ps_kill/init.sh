#!/bin/bash


if PYTHON=$(command -v python3)
then
    sed -e $'1c\\\n'"#!$PYTHON" "$MISSION_DIR/spell.py" > "$GSH_VAR/$(gettext "spell")"
else
    BASH=$(command -v bash)
    sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/spell.sh" > "$GSH_VAR/$(gettext "spell")"
fi
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" &
echo $! > "$GSH_VAR"/spell.pid
disown
