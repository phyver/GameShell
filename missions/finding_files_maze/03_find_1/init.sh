#!/usr/bin/env sh

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

  dir=$(generate_maze.sh "$maze" 3 10 2)

  dir1=$(echo "$dir" | sed -n '1p;1q')
  dir2=$(echo "$dir" | sed -n '2p;2q')
  checksum "$dir1" > "$dir1/$(gettext "gold_coin")_1"
  checksum "$dir1" > "$GSH_TMP/gold_coin_1"
  checksum "$dir2" > "$dir2/$(gettext "GolD_CoiN")_2"
  checksum "$dir2" > "$GSH_TMP/GolD_CoiN_2"

  return 0
)

_mission_init
