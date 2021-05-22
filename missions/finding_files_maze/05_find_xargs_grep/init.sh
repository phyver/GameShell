#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  local maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
  rm -rf "$maze"/?*

  mkdir -p "$maze"

  local file
  if ! command -v python3 &> /dev/null
  then
    file=$(maze2.sh "$maze" 10 1 "$(gettext "stone")")
  else
    file=$(maze2.py "$maze" 3 10 1 "$(gettext "stone")")
  fi
  local R=$(basename "$file")
  local sum=$(checksum "$R $(gettext "diamond")")
  echo "$R $(gettext "diamond") $sum" > "$maze/$file"
  echo "$R $(gettext "diamond") $sum" > "$GSH_VAR/diamond"
}

_mission_init
