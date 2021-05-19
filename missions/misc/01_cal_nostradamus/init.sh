#!/bin/bash

_mission_init() {
  local YYYY=$((1900 + RANDOM % 300))
  local MM=$(printf "%02d" "$((1 + RANDOM % 12))")
  local DD=$(printf "%02d" "$((13 + RANDOM % 5))")
  echo "$YYYY-$MM-$DD" > $GSH_VAR/date
}

_mission_init
