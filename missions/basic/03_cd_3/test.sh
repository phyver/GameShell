cd
gsh assert check false


history -s cd
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check
cd
gsh assert check false
history -d -3--1

history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s cd ../../../
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check
cd
gsh assert check false
history -d -3--1


cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s cd
history -s cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room')"
history -s gsh check
gsh assert check true
history -d -3--1
