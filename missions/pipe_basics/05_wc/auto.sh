cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s "tail -n +4 \"$(gettext "Book_of_Potions")/$(gettext "page")_06\" | wc - l"
history -s "gsh check"
gsh check

history -d -2--1
