#!/bin/sh

_mission_init() (
  if ! [ -e "$MISSION_DIR/ascii-art" ]
  then
    DUMMY_MISSION=$(missionname "$MISSION_DIR/ascii-art")
    echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
    unset DUMMY_MISSION
    return 1
  fi

  CELLAR=$(eval_gettext "\$GSH_HOME/Castle/Cellar")
  mkdir -p "$CELLAR"
  rm -f "$CELLAR"/*_"$(gettext "spider")"_*

  RANDOM 100 | for I in $(seq 50)
  do
    read RANDOM
    spider=${CELLAR}/${RANDOM}_$(gettext "spider")_$I
    read RANDOM
    cp "$MISSION_DIR/ascii-art/spider-$((RANDOM%3)).txt" "$spider"
  done

  RANDOM 10 | for I in $(seq 5)
  do

    read RANDOM
    bat=${CELLAR}/${RANDOM}_$(gettext "bat")_$I
    read RANDOM
    cp "$MISSION_DIR/ascii-art/bat-$((RANDOM%3)).txt" "$bat"
  done

  find "$CELLAR" -maxdepth 1 -name "*_$(gettext "bat")_*" | sort | checksum > "$GSH_TMP/bats"
  return 0
)

_mission_init
