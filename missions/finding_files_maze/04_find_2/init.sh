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

  dir=$(generate_maze.sh "$maze" 3 10 6)

  dir1=$(echo "$dir" | head -n 1)
  R=$(RANDOM)
  sum=$(checksum "$R $(gettext "ruby")")
  echo "$R $(gettext "rubino") $sum" > "$dir1/$R"
  echo "$R $(gettext "rubino") $sum" > "$GSH_TMP/ruby"

  echo "$dir" | sed '1d' | while read dir1
  do
    R=$(RANDOM)
    sum=$(checksum "$R $(gettext "pietra")")
    echo "$R $(gettext "pietra") $sum" > "$dir1/$R"
  done

  return 0
)

_mission_init
