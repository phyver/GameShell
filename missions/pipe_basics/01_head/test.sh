cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

history -s head -n 6 $(gettext "Book_of_Potions")/$(gettext "page")_07
history -s gash check
gash assert check true
history -d -2--1

history -s head -n 6 $(gettext "Book_of_Potions")/$(gettext "page")_07
history -s something something
history -s gash check
gash assert check false
history -d -3--1

history -s head -n 5 $(gettext "Book_of_Potions")/$(gettext "page")_07
history -s gash check
gash assert check false
history -d -2--1

history -s head -n 7 $(gettext "Book_of_Potions")/$(gettext "page")_07
history -s gash check
gash assert check false
history -d -2--1

sed -i '1d' $(gettext "Book_of_Potions")/$(gettext "page")_07
history -s head -n 4 $(gettext "Book_of_Potions")/$(gettext "page")_07
history -s gash check
gash assert check false
history -d -2--1
