#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  find "$GSH_HOME" -iname "$(gettext "painting")_*" -print0 | xargs -0 rm -rf

  local filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-pipe" > "$filename"
  local Y=$((1980 + RANDOM%10))
  local M=$(printf "%02d" $((1 + RANDOM%12)))
  local D=$(printf "%02d" $((1 + RANDOM%28)))
  local h=$(printf "%02d" $((RANDOM%24)))
  local m=$(printf "%02d" $((RANDOM%60)))
  local s=$(printf "%02d" $((RANDOM%60)))
  echo "$(basename "$filename")" > "$GSH_VAR/painting"
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"

  filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-star_wars" > "$filename"
  sign_file "$filename"
  touch "$filename"

  filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
  box.sh -B Diamond "$MISSION_DIR/ascii-art/painting-joconde" > "$filename"
  Y=$(date +%Y)
  Y=$((Y + 1 + RANDOM%10))
  M=$(printf "%02d" $((1 + RANDOM%12)))
  D=$(printf "%02d" $((1 + RANDOM%28)))
  h=$(printf "%02d" $((RANDOM%24)))
  m=$(printf "%02d" $((RANDOM%60)))
  s=$(printf "%02d" $((RANDOM%60)))
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"
}

_mission_init
