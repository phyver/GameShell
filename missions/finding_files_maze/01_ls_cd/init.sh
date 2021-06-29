#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  if ! command -v generate_maze.sh >/dev/null
  then
    DUMMY_MISSION=$(readlink-f "$MISSION_DIR/../00_shared")
    DUMMY_MISSION=${DUMMY_MISSION#$GSH_MISSIONS/}
    echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
    return 1
  fi

  maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
  mkdir -p "$maze"

  d=$(generate_maze.sh "$maze" 3 2 1)

  echo "$(checksum "$d")" > "$d/OOOOO_$(gettext "copper_coin")_OOOOO"
  echo "$(checksum "$d")" > "$GSH_TMP/copper_coin"

  return 0
)
_mission_init
