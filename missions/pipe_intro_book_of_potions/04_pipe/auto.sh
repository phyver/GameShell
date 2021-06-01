cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s "cat \"$(gettext "Book_of_potions")/$(gettext "page")_0\"[34] | tail -n 16"
history -s gsh check
gsh check

# macOS' version of bash is too old and we cannot delete ranges of commands in
# history
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n
