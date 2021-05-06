cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

history -s "tail -n 9 $(gettext "Book_of_Potions")/$(gettext "page")_12"
history -s "gash check"
gash assert check true
history -d -2--1

history -s "tail -n 9 $(gettext "Book_of_Potions")/$(gettext "page")_12"
history -s "something something"
history -s "gash check"
gash assert check false
history -d -3--1

history -s "tail -n 10 $(gettext "Book_of_Potions")/$(gettext "page")_12"
history -s "gash check"
gash assert check false
history -d -2--1

history -s "tail -n 8 $(gettext "Book_of_Potions")/$(gettext "page")_12"
history -s "gash check"
gash assert check false
history -d -2--1

sed -i '1d' $(gettext "Book_of_Potions")/$(gettext "page")_12
history -s "tail -n 9 $(gettext "Book_of_Potions")/$(gettext "page")_12"
history -s "gash check"
gash assert check false
history -d -2--1
