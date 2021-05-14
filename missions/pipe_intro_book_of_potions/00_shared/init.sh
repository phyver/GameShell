#!/bin/bash

# Install the book for the mission.
bash "$GSH_MISSIONS_BIN/install_potion_book.sh" book "$(eval_gettext '$GSH_HOME/Mountain/Cave')/"

# Install a copy for later checks. TODO: only do that in the check file?
bash "$GSH_MISSIONS_BIN/install_potion_book.sh" book "$GSH_VAR/book_of_potions"

# put Servillus in the cave
sign_file $MISSION_DIR/../00_shared/ascii-art/servillus.txt "$(eval_gettext '$GSH_HOME/Mountain/Cave')/servillus"
