#!/usr/bin/env sh

gsh assert check false

chmod +x "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
gsh assert check true

cd
gsh assert check false
