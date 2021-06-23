#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
add_cmd tail -n 9 "$(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd gsh check
gsh check

. history_clean.sh
