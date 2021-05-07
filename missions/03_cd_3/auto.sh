cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s cd
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check

gsh check

history -d -3--1
