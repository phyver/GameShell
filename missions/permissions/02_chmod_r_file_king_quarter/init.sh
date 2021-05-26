#!/bin/bash

_mission_init() {
  if ! command -v man &> /dev/null; then
    echo "$(eval_gettext "The command 'man' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'man-db')")" >&2
    return 1
  fi

  local dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
  local key=$RANDOM$RANDOM
  echo "$key" > "$GSH_VAR/key"
  echo "$key" > "$dir/.$(gettext "secret_note")"
  echo "0123456789" > "$dir/$(gettext "note")"
  chmod -r "$dir/.$(gettext "secret_note")"
}

_mission_init
