#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  mission_source "$MISSION_DIR/init0.sh"

  local great_hall="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"

  local D=$(date +%s)

  local i
  for i in $(seq 4)
  do
    local f="$(gettext "standard")_${i}"
    touch "${great_hall}/${f}"
    sign_file "${great_hall}/${f}"
  done

  ls "$great_hall" | sort > "$GSH_VAR/great_hall_contents"
}

_mission_init
