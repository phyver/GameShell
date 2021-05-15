#!/usr/bin/env bash

chmod +x "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
gsh check
