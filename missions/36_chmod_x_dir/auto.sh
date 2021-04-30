#!/bin/bash

chmod +x "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
gash check
