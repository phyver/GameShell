#!/usr/bin/env bash

gsh assert check false

chmod +x "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
gsh assert check true

gsh assert check false
