cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s tail -n 9 "$(gettext "Book_of_Potions")/$(gettext "page")_12"
history -s gash check
gash check

history -d -2--1
