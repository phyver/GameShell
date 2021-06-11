#!/bin/bash

# the ``history`` command is not in POSIX

cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

history -s "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
history -s "gsh check"
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "tail -n 9 \"$(gettext "Book_of_potions")/$(gettext "page")_13\" | head -n 3"
history -s "gsh check"
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "sed -n '4,6p' \"$(gettext "Book_of_potions")/$(gettext "page")_13\""
history -s "gsh check"
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "sed -n '3,6p' \"$(gettext "Book_of_potions")/$(gettext "page")_13\""
history -s "gsh check"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "awk '4<=NR && NR<=6 {print}' \"$(gettext "Book_of_potions")/$(gettext "page")_13\""
history -s "gsh check"
gsh assert check true
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n

history -s "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
history -s "something something"
history -s "gsh check"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-2))
history -d $((n-2))
history -d $((n-2))
unset n

sed-i '1d' "$(gettext "Book_of_potions")/$(gettext "page")_01"
history -s "head -n 6 \"$(gettext "Book_of_potions")/$(gettext 'page')_13\" | tail -n 3"
history -s "gsh check"
gsh assert check false
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n
