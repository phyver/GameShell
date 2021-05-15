cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "tail -n +4 \"$(gettext "Book_of_potions")/$(gettext 'page')_06\" | wc -l"
history -s "gsh check"
gsh assert check true
history -d -2--1

history -s "tail -n +4 \"$(gettext "Book_of_potions")/$(gettext 'page')_06\""
history -s "gsh check"
gsh assert check false
history -d -2--1

history -s "tail -n +4 \"$(gettext "Book_of_potions")/$(gettext 'page')_06\" | wc -l"
history -s "something something"
history -s "gsh check"
gsh assert check false
history -d -3--1

SED-i '1d' $(gettext "Book_of_potions")/$(gettext "page")_01
history -s "tail -n +4 \"$(gettext "Book_of_potions")/$(gettext 'page')_06\" | wc -l"
history -s "gsh check"
gsh assert check false
history -d -2--1
