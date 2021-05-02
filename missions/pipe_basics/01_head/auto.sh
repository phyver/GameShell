cd "$(eval_gettext '$GASH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s head -n 6 "$(gettext "Book_of_Potions")/$(gettext "page")_07"
history -s gash check
gash check

history -d -2--1
