#!/bin/sh

. alt_history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

add_cmd "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
gsh assert check true

add_cmd "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "something something"
gsh assert check false

add_cmd "tail -n 10 $(gettext "Book_of_potions")/$(gettext "page")_12"
gsh assert check false

add_cmd "tail -n 8 $(gettext "Book_of_potions")/$(gettext "page")_12"
gsh assert check false

sed-i '1d' "$(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
gsh assert check false

. alt_history_stop.sh
