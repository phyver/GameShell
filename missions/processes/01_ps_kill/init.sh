#!/bin/bash

if PYTHON_PATH=$(command -v python3)
then
    { echo "#!$PYTHON_PATH" ; sed "1d" "$MISSION_DIR/spell.py" ; } > "$GSH_VAR/$(gettext "spell")"
else
    cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
fi
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" &
echo $! > "$GSH_VAR"/spell.pid
disown
unset PYTHON_PATH BASH_PATH
