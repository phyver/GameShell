#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  find "$GSH_HOME" -iname "$(gettext "painting")_*" -print0 | xargs -0 rm -rf

  local filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
  parchment "$MISSION_DIR/ascii-art/painting-pipe" Diamond > "$filename"
  local Y=$((1980 + RANDOM%10))
  local M=$(echo 0$((1 + RANDOM%12)) | cut -c 1-2)
  local D=$(echo 0$((1 + RANDOM%28)) | cut -c 1-2)
  local h=$(echo 0$((RANDOM%24)) | cut -c 1-2)
  local m=$(echo 0$((RANDOM%60)) | cut -c 1-2)
  local s=$(echo 0$((RANDOM%60)) | cut -c 1-2)
  echo "$(basename "$filename")" > "$GSH_VAR/painting"
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"

  filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
  parchment "$MISSION_DIR/ascii-art/painting-star_wars" Diamond > "$filename"
  sign_file "$filename"
  touch "$filename"

  filename=$(mktemp "$(eval_gettext '$GSH_HOME/Castle/Main_tower/First_floor')"/$(gettext "painting")_XXXXXX)
  parchment "$MISSION_DIR/ascii-art/painting-joconde" Diamond  > "$filename"
  Y=$(date +%Y)
  Y=$((Y + 1 + RANDOM%10))
  M=$(echo 0$((1 + RANDOM%12)) | cut -c 1-2)
  D=$(echo 0$((1 + RANDOM%28)) | cut -c 1-2)
  h=$(echo 0$((RANDOM%24)) | cut -c 1-2)
  m=$(echo 0$((RANDOM%60)) | cut -c 1-2)
  s=$(echo 0$((RANDOM%60)) | cut -c 1-2)
  sign_file "$filename"
  touch -t "$Y$M$D$h$m.$s" "$filename"
}

_mission_init
