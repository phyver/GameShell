#!/bin/bash

_mission_init() {
  if ! command -v generate_maze.sh &> /dev/null
  then
    local DUMMY_MISSION=$(realpath "$MISSION_DIR/../00_shared")
    DUMMY_MISSION=${DUMMY_MISSION#$GSH_MISSIONS/}
    echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
    return 1
  fi

  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  local maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
  mkdir -p "$maze"

  local d=$(generate_maze.sh "$maze" 3 2 1)

  echo "$(checksum "$d")" > "$d/OOOOO_$(gettext "copper_coin")_OOOOO"
  echo "$(checksum "$d")" > "$GSH_VAR/copper_coin"

  return 0
}
_mission_init
