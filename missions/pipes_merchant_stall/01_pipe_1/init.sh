#!/bin/bash

generate_merchant_stall.py 10000 2000 0.995 "$(eval_gettext '$GSH_HOME/Stall')"

mission_source "$MISSION_DIR/../00_shared/count_commands.sh"
