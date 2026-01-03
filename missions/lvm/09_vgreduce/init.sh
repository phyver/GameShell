#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_init() (

  lvm_init "09" 
  return $?

)

_mission_init
