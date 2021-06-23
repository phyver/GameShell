#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

add_cmd "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "gsh check"
gsh assert check true

add_cmd "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "something something"
add_cmd "gsh check"
gsh assert check false

add_cmd "tail -n 10 $(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "gsh check"
gsh assert check false

add_cmd "tail -n 8 $(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "gsh check"
gsh assert check false

sed-i '1d' "$(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
add_cmd "gsh check"
gsh assert check false

. history_clean.sh
