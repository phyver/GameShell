#!/usr/bin/env sh

echo "$(gettext "What's the key that will make Merlin's chest to appear?")"
read -r dcode

if [ "$dcode" = "$(cat "$GSH_TMP/magic_word")" ]
then
  merlin_chest=$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')/$(gettext 'Merlin_s_chest')
  mkdir -p "$merlin_chest"
  cp "$(eval_gettext '$MISSION_DIR/secret_recipe/en.txt')" "$merlin_chest/$(gettext 'secret_recipe')"
  sign_file "$MISSION_DIR/ascii-art/medal.txt"  "$merlin_chest/$(gettext 'medal')"
  sign_file "$MISSION_DIR/ascii-art/bottle.txt"  "$merlin_chest/$(gettext 'bottle')"
  unset merlin_chest dcode
  true
else
  echo "$(gettext "That's not the magic word.")"
  unset dcode
  false
fi

