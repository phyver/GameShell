cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[34] | tail -n 16"
history -s gsh check
gsh check

history -d -2--1
