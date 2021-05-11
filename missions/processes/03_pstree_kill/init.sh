#!/bin/bash

cp "$MISSION_DIR/nice_fairy.sh" "$GSH_VAR/$(gettext "nice_fairy")"
mkdir -p "$GSH_VAR/fairy/"
cp "$MISSION_DIR/fairy/spell.sh" "$GSH_VAR/fairy/$(gettext "spell")"
chmod 755 "$GSH_VAR/fairy/$(gettext "spell")"
"$GSH_VAR/$(gettext "nice_fairy")" &
echo "$!" > "$GSH_VAR/fairy.pid"

cp "$MISSION_DIR/mischievous_imp.sh" "$GSH_VAR/$(gettext "mischievous_imp")"
mkdir -p "$GSH_VAR/imp/"
cp "$MISSION_DIR/imp/spell.sh" "$GSH_VAR/imp/$(gettext "spell")"
chmod 755 "$GSH_VAR/imp/$(gettext "spell")"
"$GSH_VAR/$(gettext "mischievous_imp")" &
echo "$!" > "$GSH_VAR/imp.pid"
