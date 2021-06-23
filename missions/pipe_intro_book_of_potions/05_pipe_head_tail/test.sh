#!/bin/sh

. history_start.sh

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

add_cmd "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
add_cmd gsh check
gsh assert check true

add_cmd "tail -n 9 \"$(gettext "Book_of_potions")/$(gettext "page")_13\" | head -n 3"
add_cmd gsh check
gsh assert check true

add_cmd "sed -n '4,6p' \"$(gettext "Book_of_potions")/$(gettext "page")_13\""
add_cmd gsh check
gsh assert check true

add_cmd "sed -n '3,6p' \"$(gettext "Book_of_potions")/$(gettext "page")_13\""
add_cmd gsh check
gsh assert check false

add_cmd "awk '4<=NR && NR<=6 {print}' \"$(gettext "Book_of_potions")/$(gettext "page")_13\""
add_cmd gsh check
gsh assert check true

add_cmd "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
add_cmd "something something"
add_cmd gsh check
gsh assert check false

sed-i '1d' "$(gettext "Book_of_potions")/$(gettext "page")_01"
add_cmd "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
add_cmd gsh check
gsh assert check false

. history_clean.sh
