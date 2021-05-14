#!/bin/bash

entrance="$(eval_gettext '$GSH_HOME/Castle/Entrance')"

sign_file "$MISSION_DIR/ascii-art/stag_head.txt" "$entrance/$(gettext "stag_head")_$RANDOM"
sign_file "$MISSION_DIR/ascii-art/shield.txt" "$entrance/$(gettext "decorative_shield")_$RANDOM"
sign_file "$MISSION_DIR/ascii-art/armour.txt" "$entrance/$(gettext "suit_of_armour")_$RANDOM"
