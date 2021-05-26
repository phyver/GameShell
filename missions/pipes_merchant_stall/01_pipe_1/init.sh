#!/bin/bash

_mission_init() {
  if ! command -v python3 &> /dev/null
  then
    echo "$(eval_gettext "The command 'python3' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'python3')")" >&2
    return 1
  elif ! command -v generate_merchant_stall.py &> /dev/null
  then
    # FIXME: change message
    echo "$(eval_gettext "The script 'generate_merchant_stall.py' is necessary for mission \$MISSION_NAME.
Make sure the corresponding mission is included.")" >&2
    return 1
  fi

  generate_merchant_stall.py 10000 2000 0.995 "$(eval_gettext '$GSH_HOME/Stall')"

  mission_source "$MISSION_DIR/../00_shared/count_commands.sh"

  return 0
}
_mission_init
