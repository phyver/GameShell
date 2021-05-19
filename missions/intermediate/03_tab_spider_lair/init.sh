#!/bin/bash

_mission_init() {
  local r1=$(CHECKSUM $RANDOM)
  local r2=$(CHECKSUM $RANDOM)
  local lair="$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext ".Lair_of_the_spider_queen") ${r1} ${r2}"
  mkdir -p "$lair"

  r1=$(CHECKSUM $RANDOM)
  r2=$(CHECKSUM $RANDOM)
  local queen="${r1}_$(gettext "spider_queen")_$r2"
  sign_file "$MISSION_DIR/ascii-art/spider-queen.txt" "$lair/$queen"

  r1=$(CHECKSUM $RANDOM)
  r2=$(CHECKSUM $RANDOM)
  local bat="${r1}_$(gettext "baby_bat")_$r2"
  sign_file "$MISSION_DIR/ascii-art/baby-bat.txt" "$lair/$bat"

  date +%s > "$GSH_VAR/start_time"
}

set -o noglob
_mission_init
