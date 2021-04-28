cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

history -s "tail -n 8 \"$(gettext "potion_recipe")\" | head -n 3"
history -s gash check
gash assert check true
history -d -2--1

history -s "head -n 11 \"$(gettext "potion_recipe")\" | tail -n 3"
history -s gash check
gash assert check true
history -d -2--1

history -s "head -n 11 \"$(gettext "potion_recipe")\" | tail -n 3"
history -s something something
history -s gash check
gash assert check false
history -d -3--1

history -s "head -n 10 \"$(gettext "potion_recipe")\" | tail -n 3"
history -s gash check
gash assert check false
history -d -2--1

history -s "head -n 12 \"$(gettext "potion_recipe")\" | tail -n 3"
history -s gash check
gash assert check false
history -d -2--1

history -s "head -n 11 \"$(gettext "potion_recipe")\" | tail -n 4"
history -s gash check
gash assert check false
history -d -2--1

history -s "head -n 11 \"$(gettext "potion_recipe")\" | tail -n 2"
history -s gash check
gash assert check false
history -d -2--1

sed -i '6d' $(gettext "potion_recipe")
history -s "head -n 11 \"$(gettext "potion_recipe")\" | tail -n 3"
history -s gash check
gash assert check false
history -d -2--1
