#!/usr/bin/env bash

BASH=$(command -v bash)

sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/nice_fairy.sh" > "$GSH_VAR/$(gettext "nice_fairy")"
chmod 755 "$GSH_VAR/$(gettext "nice_fairy")"

mkdir -p "$GSH_VAR/fairy/"
sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/fairy/spell.sh" >  "$GSH_VAR/fairy/$(gettext "spell")"
chmod 755 "$GSH_VAR/fairy/$(gettext "spell")"
"$GSH_VAR/$(gettext "nice_fairy")" &
echo "$!" > "$GSH_VAR/fairy.pid"

sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/mischievous_imp.sh" > "$GSH_VAR/$(gettext "mischievous_imp")"
chmod 755 "$GSH_VAR/$(gettext "mischievous_imp")"
mkdir -p "$GSH_VAR/imp/"
sed -e $'1c\\\n'"#!$BASH" "$MISSION_DIR/imp/spell.sh" >  "$GSH_VAR/imp/$(gettext "spell")"
chmod 755 "$GSH_VAR/imp/$(gettext "spell")"
"$GSH_VAR/$(gettext "mischievous_imp")" &
echo "$!" > "$GSH_VAR/imp.pid"
