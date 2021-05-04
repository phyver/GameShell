#!/bin/bash

# Install the book for the mission.
bash "$GASH_LOCAL_BIN/install_potion_book.sh" book "$(eval_gettext '$GASH_HOME/Mountain/Cave')/"

# Install a copy for later checks. TODO: only do that in the check file?
bash "$GASH_LOCAL_BIN/install_potion_book.sh" book "$GASH_MISSION_DATA/book_of_potions"
