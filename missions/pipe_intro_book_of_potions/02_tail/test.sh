cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
history -s "gsh check"
gsh assert check true
history -d -2--1

history -s "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
history -s "something something"
history -s "gsh check"
gsh assert check false
history -d -3--1

history -s "tail -n 10 $(gettext "Book_of_potions")/$(gettext "page")_12"
history -s "gsh check"
gsh assert check false
history -d -2--1

history -s "tail -n 8 $(gettext "Book_of_potions")/$(gettext "page")_12"
history -s "gsh check"
gsh assert check false
history -d -2--1

SED-i '1d' $(gettext "Book_of_potions")/$(gettext "page")_12
history -s "tail -n 9 $(gettext "Book_of_potions")/$(gettext "page")_12"
history -s "gsh check"
gsh assert check false
history -d -2--1
