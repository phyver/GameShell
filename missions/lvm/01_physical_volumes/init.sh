#!/usr/bin/env sh

_mission_init() (
  if ! [ -e "$MISSION_DIR/../00_shared/" ]
  then
    DUMMY_MISSION=$(missionname "$MISSION_DIR/../00_shared/")
    echo "$(eval_gettext "Dummy mission '\$DUMMY_MISSION' is required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
    unset DUMMY_MISSION
    return 1
  fi

  LOOP1_PATH="/dev/gsh_lvm_loop1"
  LOOP2_PATH="/dev/gsh_lvm_loop2"

  if ! [ -e "$LOOP1_PATH" ] || ! [ -e "$LOOP2_PATH" ]
  then
    echo "$(eval_gettext "Loop devices \$LOOP1_PATH and \$LOOP2_PATH are required for mission \$MISSION_NB (\$MISSION_NAME).")" >&2
    return 1
  fi

  # prepare world/dev
  SDBA="$GSH_HOME/dev/sda"
  SDBB="$GSH_HOME/dev/sdb"
  ln -sf "$LOOP1_PATH" "$SDBA"
  ln -sf "$LOOP2_PATH" "$SDBB"

  return 0
)

_mission_init
