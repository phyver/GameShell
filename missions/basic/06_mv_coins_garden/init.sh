#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  for i in $(seq 3)
  do
    C="$(gettext "coin")_$i"
    touch "$(eval_gettext "\$GSH_HOME/Garden")/$C"
    sign_file "$(eval_gettext "\$GSH_HOME/Garden")/$C"
  done
)

_mission_init
