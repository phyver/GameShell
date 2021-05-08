cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "cat \"$(gettext "Book_of_potions")/$(gettext 'page')_0\"[34] | tail -n 16"
history -s "gsh check"
gsh assert check true
history -d -2--1

history -s "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[34]"
history -s "gsh check"
gsh assert check false
history -d -2--1

history -s "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[34] | tail -n 16"
history -s "something something"
history -s "gsh check"
gsh assert check false
history -d -3--1

sed -i '1d' $(gettext "Book_of_potions")/$(gettext "page")_01
history -s "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[34] | tail -n 16"
history -s "gsh check"
gsh assert check false
history -d -2--1
