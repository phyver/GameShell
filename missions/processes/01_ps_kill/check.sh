#!/bin/sh

_mission_check() (
  if my_ps $(cat "$GSH_VAR/spell.pid") | grep -q "$(gettext "spell")"
  then
    echo "$(gettext "The spell is still running!")"
    return 1
  fi
  return 0
)

_mission_check
