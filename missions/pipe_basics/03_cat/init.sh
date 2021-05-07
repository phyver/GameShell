#!/bin/bash

# Install the book for the mission.
bash "$GSH_LOCAL_BIN/install_potion_book.sh" book "$(eval_gettext '$GSH_HOME/Mountain/Cave')/"

# Install a copy for later checks. TODO: only do that in the check file?
bash "$GSH_LOCAL_BIN/install_potion_book.sh" book "$GSH_MISSION_DATA/book_of_potions"
