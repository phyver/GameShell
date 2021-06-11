#!/bin/sh

rm -f "$(eval_gettext '$GSH_HOME/Mountain/Cave')/servillus"
sign_file "$MISSION_DIR/ascii-art/cauldron.txt" "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "cauldron")"

rm -rf "$GSH_TMP/book_of_potions"
