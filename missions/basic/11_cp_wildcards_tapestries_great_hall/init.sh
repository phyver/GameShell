#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  mission_source "$MISSION_DIR/init0.sh"

  local D=$(date +%s)

  local great_hall="$(eval_gettext "\$GSH_HOME/Castle/Great_hall")"
  local i
  for i in $(seq -w 10)
  do
    local f=$great_hall/${RANDOM}_$(gettext "tapestry")_$i
    cp "$MISSION_DIR/ascii-art/tapestry-$((RANDOM%5)).txt" "$f"
    sign_file "$f"
  done

  ls "$great_hall" | sort > "$GSH_VAR/great_hall_contents"
}

_mission_init
