#!/bin/sh

if ! command -v nano >/dev/null; then
  echo "$(eval_gettext "The command 'nano' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'nano')")" >&2
  false
else
  [ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
  mkdir -p "$GSH_CHEST"
fi
