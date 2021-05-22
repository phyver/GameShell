#!/bin/bash

_mission_init() {
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"

  local maze="$(eval_gettext '$GSH_HOME/Garden/Maze')"
  rm -rf "$maze"/?*

  mkdir -p "$maze"
  local dir
  if ! command -v python3 &> /dev/null
  then
    dir=$(maze1.sh "$maze" 10 6)
  else
    dir=$(maze1.py "$maze" 3 10 6)
  fi
  local dir1=$(echo "$dir" | head -n 1)
  local R=$RANDOM
  local sum=$(checksum "$R $(gettext "ruby")")
  echo "$R $(gettext "ruby") $sum" > "$maze/$dir1/$R"
  echo "$R $(gettext "ruby") $sum" > "$GSH_VAR/ruby"

  echo "$dir" | sed '1d' | while read dir1
  do
    R=$RANDOM
    sum=$(checksum "$R $(gettext "stone")")
    echo "$R $(gettext "stone") $sum" > "$maze/$dir1/$R"
  done
}

_mission_init
