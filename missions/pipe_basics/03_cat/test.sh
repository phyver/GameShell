cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

history -s cat "$(gettext "Book_of_Potions")/$(gettext "page")_01" "$(gettext "Book_of_Potions")/$(gettext "page")_02"
history -s gash check
gash assert check true
history -d -2--1

history -s cat "$(gettext "Book_of_Potions")/$(gettext "page")_01" "$(gettext "Book_of_Potions")/$(gettext "page")_02"
history -s something something
history -s gash check
gash assert check false
history -d -3--1

history -s cat "$(gettext "Book_of_Potions")/$(gettext "page")_02" "$(gettext "Book_of_Potions")/$(gettext "page")_01"
history -s gash check
gash assert check false
history -d -2--1

history -s cat "$(gettext "Book_of_Potions")/$(gettext "page")_01"
history -s gash check
gash assert check false
history -d -2--1

history -s cat "$(gettext "Book_of_Potions")/$(gettext "page")_02"
history -s gash check
gash assert check false
history -d -2--1

sed -i '1d' $(gettext "Book_of_Potions")/$(gettext "page")_01
history -s cat "$(gettext "Book_of_Potions")/$(gettext "page")_01" "$(gettext "Book_of_Potions")/$(gettext "page")_02"
history -s gash check
gash assert check false
history -d -2--1
