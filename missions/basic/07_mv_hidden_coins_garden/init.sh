#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  rm -f "$(eval_gettext '$GSH_HOME/Garden')/.$(gettext "coin")_"*

  for i in $(seq 3)
  do
    f=$(eval_gettext '$GSH_HOME/Garden')/.$(RANDOM)_$(gettext "coin")_$i
    touch "$f"
    sign_file "$f"
  done
)

_mission_init
