#!/bin/sh

. alt_history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[34] | tail -n 16"
gsh check

. alt_history_stop.sh
