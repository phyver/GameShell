#!/bin/bash

_mission_init() {

  if ! [ -e "$MISSION_DIR/deps.sh" ]
  then
    # FIXME
    echo "missing dummy mission!"
    return 1
  fi

  mission_source "$MISSION_DIR/deps.sh" || return 1

  local PYTHON_PATH
  if PYTHON_PATH=$(command -v python3)
  then
    { echo "#!$PYTHON_PATH" ; sed "1d" "$MISSION_DIR/spell.py" ; } > "$GSH_VAR/$(gettext "spell")"
    else
      cp "$MISSION_DIR/spell.sh" "$GSH_VAR/$(gettext "spell")"
  fi
  chmod 755 "$GSH_VAR/$(gettext "spell")"
  "$GSH_VAR/$(gettext "spell")" "$TEXTDOMAIN" &
  disown
  return 0
}

_mission_init
