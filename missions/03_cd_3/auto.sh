# Commands must be manually added to the history.
history -s cd
history -s cd "$(eval_gettext "\$GASH_HOME/Castle/Main_building/Throne_room")"
history -s gash check

cd
cd "$(eval_gettext "\$GASH_HOME/Castle/Main_building/Throne_room")"
gash check

# Cleaning up the history.
history -d -3--1
