cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s cd
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check

gsh check

# macOS' version of bash is too old and we cannot delete ranges of commands in
# history
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-2))
history -d $((n-2))
history -d $((n-2))
unset n
