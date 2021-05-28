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
  rm -rf "$maze"/?*

  mkdir -p "$maze"

  local file=$(generate_maze.sh "$maze" 3 10 1 "$(gettext "stone")")

  local R=$(basename "$file")
  local sum=$(checksum "$R $(gettext "diamond")")
  echo "$R $(gettext "diamond") $sum" > "$file"
  echo "$R $(gettext "diamond") $sum" > "$GSH_VAR/diamond"

  return 0
}
_mission_init
