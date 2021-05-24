#!/bin/bash

if PYTHON_PATH=$(command -v python3)
then
    { echo "#!$PYTHON_PATH" ; sed "1d" "$MISSION_DIR/spell.py" ; } > "$GSH_VAR/$(gettext "spell")"
else
<<<<<<< Updated upstream
    cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
=======
    cp "$MISSION_DIR/spell.sh" > "$GSH_VAR/$(gettext "spell")"
>>>>>>> Stashed changes
fi
chmod 755 "$GSH_VAR/$(gettext "spell")"
"$GSH_VAR/$(gettext "spell")" "$TEXTDOMAIN" &
disown
unset PYTHON_PATH BASH_PATH
