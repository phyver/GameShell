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
  rm -f "$CELLAR"/.??*

  for I in $(seq 100)
  do
    spider=${CELLAR}/.$(RANDOM)_$(gettext "spider")_$I
    sign_file "$MISSION_DIR/ascii-art/spider-$(($(RANDOM)%3)).txt" "$spider"
    if [ "$((I%5))" -eq 0 ]
    then
      printf "."
    fi
  done

  for I in $(seq 10)
  do
    bat=${CELLAR}/.$(RANDOM)_$(gettext "bat")_$I
    sign_file "$MISSION_DIR/ascii-art/bat-$(($(RANDOM)%3)).txt" "$bat"
    if [ "$((I%5))" -eq 0 ]
    then
      printf "."
    fi
  done

  find "$CELLAR" -maxdepth 1 -name "*_$(gettext "bat")_*" | sort | checksum > "$GSH_VAR/bats"

  return 0
)

. progress_bar.sh _mission_init
