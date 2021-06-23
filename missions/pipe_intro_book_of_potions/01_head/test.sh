#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

add_cmd "head -n 6 $(gettext "Book_of_potions")/$(gettext "page")_07"
gsh assert check true

add_cmd "head -n 6 $(gettext "Book_of_potions")/$(gettext "page")_07"
add_cmd "something something"
gsh assert check false

add_cmd "head -n 5 $(gettext "Book_of_potions")/$(gettext "page")_07"
gsh assert check false

sed-i '1d' "$(gettext "Book_of_potions")/$(gettext "page")_07"
add_cmd "head -n 6 $(gettext "Book_of_potions")/$(gettext "page")_07"
gsh assert check false

. history_clean.sh
