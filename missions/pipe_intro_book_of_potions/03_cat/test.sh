#!/usr/bin/env sh

. alt_history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[12]"
add_cmd gsh check
gsh assert check true

add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[12]"
add_cmd "something something"
add_cmd gsh check
gsh assert check false

add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_02\" \"$(gettext "Book_of_potions")/$(gettext "page")_01\""
add_cmd gsh check
gsh assert check false

add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_01\""
add_cmd gsh check
gsh assert check false

add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_02\""
add_cmd gsh check
gsh assert check false

sed-i '1d' "$(gettext "Book_of_potions")/$(gettext "page")_01"
add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[12]"
add_cmd gsh check
gsh assert check false

alias gc="gsh check"
add_cmd "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[12]"
add_cmd gc
gsh assert check true
unalias gc

. alt_history_stop.sh
