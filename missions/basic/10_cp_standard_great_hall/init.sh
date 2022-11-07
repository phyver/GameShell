#!/usr/bin/env sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  mission_source "$MISSION_DIR/init0.sh"

  great_hall="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"

  for i in $(seq 4)
  do
    f="$(gettext "standard")_${i}"
    touch "${great_hall}/${f}"
    sign_file "${great_hall}/${f}"
  done

  command ls "$great_hall" | sort > "$GSH_TMP/great_hall_contents"
)

_mission_init
