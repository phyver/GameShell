#!/bin/sh

_mission_init() (
  if ! command -v cal >/dev/null; then
    echo "$(eval_gettext "The command 'cal' is required for mission \$MISSION_NAME.
(Debian / Ubuntu: install package 'bsdmainutils')")" >&2
    return 1
  fi
  # keep the date between 1902 and 2038 to avoid problems with 32bits systems
  YYYY=$((1902 + $(RANDOM) % 136))
  MM=$(printf "%02d" "$((1 + $(RANDOM) % 12))")
  # keep the day strictly above 12, to avoid confusing day/month
  DD=$(printf "%02d" "$((13 + $(RANDOM) % 15))")
  echo "$YYYY-$MM-$DD" > "$GSH_TMP/date"
)

_mission_init
