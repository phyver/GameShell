cd "$(eval_gettext '$GSH_HOME/Mountain/Cave')"

# commands from a sourced file aren't saved in the history,
# we need to do that explicitly
history -s "nl \"$(eval_gettext '$MISSION_DIR/recipe/en.txt')\" | tail -n 7 | fold -s -w50"
history -s gsh check
gsh check

history -d -2--1
