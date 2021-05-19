#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  local D=$(date +%s)

  rm -f "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"*

  local i
  for i in $(seq 3)
  do
    local f=$(eval_gettext '$GSH_HOME/Garden')/.${RANDOM}_$(gettext "coin")_$i
    touch "$f"
    sign_file "$f"
  done
}

_mission_init
