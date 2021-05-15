cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
history -s "gsh check"
gsh assert check true
history -d -2--1

history -s "tail -n 9 \"$(gettext "Book_of_potions")/$(gettext "page")_13\" | head -n 3"
history -s "gsh check"
gsh assert check true
history -d -2--1

history -s "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
history -s "something something"
history -s "gsh check"
gsh assert check false
history -d -3--1

sed -i '1d' $(gettext "Book_of_potions")/$(gettext "page")_01
history -s "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
history -s "gsh check"
gsh assert check false
history -d -2--1
