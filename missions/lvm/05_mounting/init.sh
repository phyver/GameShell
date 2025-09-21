#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_init() (
  echo "mission 5"
  lvm_init "05" > /dev/null 2>&1
  return $?

)

_mission_init
