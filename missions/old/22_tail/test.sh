cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s tail -n 4  $(gettext "potion_ingredients")
history -s gsh check
gsh assert check true
history -d -2--1

history -s tail -n 4  $(gettext "potion_ingredients")
history -s something something
history -s gsh check
gsh assert check false
history -d -3--1

history -s tail -n 3  $(gettext "potion_ingredients")
history -s gsh check
gsh assert check false
history -d -2--1

history -s tail -n 5  $(gettext "potion_ingredients")
history -s gsh check
gsh assert check false
history -d -2--1

sed -i '6d' $(gettext "potion_ingredients")
history -s tail -n 4  $(gettext "potion_ingredients")
history -s gsh check
gsh assert check false
history -d -2--1
