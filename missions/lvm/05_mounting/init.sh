#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_init() (
  echo "$(eval_gettext "mission 5")"
  lvm_init "05" 
  return $?

)

_mission_init
