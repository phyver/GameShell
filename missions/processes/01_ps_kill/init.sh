#!/bin/bash

if PYTHON_PATH=$(command -v python3)
then
    sed -e $'1c\\\n'"#!$PYTHON_PATH" "$MISSION_DIR/spell.py" > "$GSH_VAR/$(gettext "spell")"
else
    BASH_PATH=$(command -v bash)
    sed -e $'1c\\\n'"#!$BASH_PATH" "$MISSION_DIR/spell.sh" > "$GSH_VAR/$(gettext "spell")"
fi
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" &
echo $! > "$GSH_VAR"/spell.pid
disown
unset PYTHON_PATH BASH_PATH
