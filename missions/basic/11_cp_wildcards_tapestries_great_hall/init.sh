#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_init() (
  if ! [ -e "$MISSION_DIR/init0.sh" ]
  then
    DUMMY_MISSION=$(missionname "$MISSION_DIR/init0.sh")
    echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")"
    unset DUMMY_MISSION
    return 1
  fi

  mission_source "$MISSION_DIR/init0.sh"

  great_hall="$(eval_gettext "\$GSH_HOME/Castle/Great_hall")"
  for i in $(seq 10)
  do
    f=$great_hall/$(RANDOM)_$(gettext "tapestry")_$(printf "%02d" "$i")
    cp "$MISSION_DIR/ascii-art/tapestry-$(($(RANDOM)%5)).txt" "$f"
    sign_file "$f"
  done

  ls "$great_hall" | sort > "$GSH_VAR/great_hall_contents"
  return 0
)

_mission_init
