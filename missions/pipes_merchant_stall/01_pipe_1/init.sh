#!/bin/bash

_mission_init() {
  if ! command -v generate_merchant_stall.sh &> /dev/null
  then
    # FIXME: change message
    echo "$(eval_gettext "The script 'generate_merchant_stall.sh' is necessary for mission \$MISSION_NAME.
Make sure the corresponding mission is included.")" >&2
    return 1
  fi

  generate_merchant_stall.sh "$(eval_gettext '$GSH_HOME/Stall')"

  mission_source "$MISSION_DIR/../00_shared/count_commands.sh"

  return 0
}
_mission_init
