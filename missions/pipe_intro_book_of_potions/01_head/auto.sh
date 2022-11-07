#!/usr/bin/env sh

. alt_history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
add_cmd head -n 6 "$(gettext "Book_of_potions")/$(gettext "page")_07"
add_cmd gsh check
gsh check

. alt_history_stop.sh
