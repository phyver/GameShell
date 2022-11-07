#!/usr/bin/env sh

_mission_init() (
  r1=$(random_string 16)
  r2=$(random_string 16)
  lair="$(eval_gettext '$GSH_HOME/Castle/Cellar')/.$(gettext "Lair_of_the_spider_queen") ${r1} ${r2}"
  mkdir -p "$lair"

  r1=$(random_string 16)
  r2=$(random_string 16)
  queen="${r1}_$(gettext "spider_queen")_$r2"
  sign_file "$MISSION_DIR/ascii-art/spider-queen.txt" "$lair/$queen"

  r1=$(random_string 16)
  r2=$(random_string 16)
  bat="${r1}_$(gettext "baby_bat")_$r2"
  sign_file "$MISSION_DIR/ascii-art/baby-bat.txt" "$lair/$bat"

  date +%s > "$GSH_TMP/start_time"
)

set -o noglob
_mission_init
