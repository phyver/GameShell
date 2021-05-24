#!/bin/bash

# this script uses 'disown' to prevent control job messages to appear on the
# screen when cleaning.
# I'm not sure if there is a way to do that in POSIX sh...

BASH_PATH=$(command -v bash)

{ echo "#!$BASH_PATH" ; sed "1d" "$MISSION_DIR/nice_fairy.sh" ; } > "$GSH_VAR/$(gettext "nice_fairy")"
chmod 755 "$GSH_VAR/$(gettext "nice_fairy")"

mkdir -p "$GSH_VAR/fairy/"
cp "$MISSION_DIR/fairy/spell.sh" "$GSH_VAR/fairy/$(gettext "spell")"
chmod 755 "$GSH_VAR/fairy/$(gettext "spell")"
"$GSH_VAR/$(gettext "nice_fairy")" &
PID=$!
disown "$PID"
echo "$PID" > "$GSH_VAR/fairy.pid"

{ echo "#!$BASH_PATH" ; sed "1d" "$MISSION_DIR/mischievous_imp.sh" ; } > "$GSH_VAR/$(gettext "mischievous_imp")"
chmod 755 "$GSH_VAR/$(gettext "mischievous_imp")"
mkdir -p "$GSH_VAR/imp/"
cp "$MISSION_DIR/imp/spell.sh" "$GSH_VAR/imp/$(gettext "spell")"
chmod 755 "$GSH_VAR/imp/$(gettext "spell")"
"$GSH_VAR/$(gettext "mischievous_imp")" &
PID=$!
disown "$PID"
echo "$PID" > "$GSH_VAR/imp.pid"

unset BASH_PATH PID
