#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  if ! command -v generate_maze.sh >/dev/null
  then
    DUMMY_MISSION=$(readlink-f "$MISSION_DIR/../00_shared")
    DUMMY_MISSION=${DUMMY_MISSION#$GSH_MISSIONS/}
    echo "$(eval_gettext "La missione esempio '\$DUMMY_MISSION' è richiesta per la missione \$MISSION_NB (\$MISSION_NAME).")" >&2
    return 1
  fi

  maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
  mkdir -p "$maze"

  file=$(generate_maze.sh "$maze" 3 10 1 "$(gettext "stone")")

  R=$(basename "$file")
  sum=$(checksum "$R $(gettext "diamante")")
  echo "$R $(gettext "diamante") $sum" > "$file"
  echo "$R $(gettext "diamante") $sum" > "$GSH_TMP/diamante"

  return 0
)

_mission_init
