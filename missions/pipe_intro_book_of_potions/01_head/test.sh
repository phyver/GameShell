cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "head -n 6 $(gettext "Book_of_potions")/$(gettext "page")_07"
history -s "gsh check"
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "head -n 6 $(gettext "Book_of_potions")/$(gettext "page")_07"
history -s "something something"
history -s "gsh check"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-2))
history -d $((n-2))
history -d $((n-2))
unset n

history -s "head -n 5 $(gettext "Book_of_potions")/$(gettext "page")_07"
history -s "gsh check"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

sed-i '1d' $(gettext "Book_of_potions")/$(gettext "page")_07
history -s "head -n 6 $(gettext "Book_of_potions")/$(gettext "page")_07"
history -s "gsh check"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n
