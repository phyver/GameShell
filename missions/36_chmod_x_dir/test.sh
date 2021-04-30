#!/bin/bash

gash assert check false

chmod +x "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
cd "$(eval_gettext '$GASH_HOME/Castle/Main_building/Throne_room/Kings_quarter')"
gash assert check true

gash assert check false
