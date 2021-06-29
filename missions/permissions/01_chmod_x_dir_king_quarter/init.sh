#!/bin/sh

_mission_init() (
  if ! command -v man >/dev/null; then
    echo "$(eval_gettext "The command 'man' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'man-db')")" >&2
    return 1
  fi

  [ "$(readlink-f "$(pwd)")" = "$(readlink-f "$dir")" ] && cd ..

  dir=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')
  chmod -x "$dir"

  return 0
)

_mission_init
