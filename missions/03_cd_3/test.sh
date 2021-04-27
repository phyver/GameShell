cd
gash assert check false


history -s cd
history -s cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')"
history -s gash check
cd
gash assert check false
history -d -3--1

history -s cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')"
history -s cd ../../../
history -s cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')"
history -s gash check
cd
gash assert check false
history -d -3--1


cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')"
history -s cd
history -s cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room')"
history -s gash check
gash assert check true
history -d -3--1
