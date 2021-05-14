#!/bin/bash

entrance="$(eval_gettext '$GSH_HOME/Castle/Entrance')"

rm -f "$entrance/"*_"$(gettext "stag_head")"
sign_file "$MISSION_DIR/ascii-art/stag_head.txt" "$entrance/${RANDOM}_$(gettext "stag_head")"
rm -f "$entrance/"*_"$(gettext "decorative_shield")"
sign_file "$MISSION_DIR/ascii-art/shield.txt" "$entrance/${RANDOM}_$(gettext "decorative_shield")"
rm -f "$entrance/"*_"$(gettext "suit_of_armour")"
sign_file "$MISSION_DIR/ascii-art/armour.txt" "$entrance/${RANDOM}_$(gettext "suit_of_armour")"
