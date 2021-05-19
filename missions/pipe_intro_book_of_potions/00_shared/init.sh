#!/bin/bash

# Install the book for the mission.
install_potion_book.sh book "$(eval_gettext '$GSH_HOME/Mountain/Cave')/"

# Install a copy for later checks. TODO: only do that in the check file?
install_potion_book.sh book "$GSH_VAR/book_of_potions"

# put Servillus in the cave
rm -f "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "cauldron")"
sign_file $MISSION_DIR/../00_shared/ascii-art/servillus.txt "$(eval_gettext '$GSH_HOME/Mountain/Cave')/servillus"
