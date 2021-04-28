cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

history -s head -n 4  $(gettext "potion_ingredients")
history -s gash check
gash assert check true
history -d -2--1

history -s head -n 4  $(gettext "potion_ingredients")
history -s something something
history -s gash check
gash assert check false
history -d -3--1

history -s head -n 3  $(gettext "potion_ingredients")
history -s gash check
gash assert check false
history -d -2--1

history -s head -n 5  $(gettext "potion_ingredients")
history -s gash check
gash assert check false
history -d -2--1

sed -i '1d' $(gettext "potion_ingredients")
history -s head -n 4  $(gettext "potion_ingredients")
history -s gash check
gash assert check false
history -d -2--1
