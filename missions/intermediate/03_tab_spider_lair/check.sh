#!/bin/sh

_mission_check() (

  # adjust
  MAX_DELAY=20


  lair="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name ".$(gettext "Lair_of_the_spider_queen")*")"
  if [ "$(realpath "$(pwd)")" != "$(realpath "$lair")" ]
  then
    echo "$(gettext "You are not in the queen spider lair!")"
    return 1
  fi

  queen=$(find "$lair" -type f -name "*$(gettext "spider_queen")*")
  if [ -n "$queen" ]
  then
    echo "$(gettext "The queen spider is still in its lair...")"
    return 1
  fi
  bat=$(find "$lair" -type f -name "*$(gettext "baby_bat")*")
  if [ -z "$bat" ]
  then
    echo "$(gettext "Where is the baby bat?")"
    return 1
  fi

  now=$(date +%s)
  start=$(cat "$GSH_VAR/start_time")
  nb_seconds=$((now - start))
  if [ "$nb_seconds" -gt "$MAX_DELAY" ]
  then
    echo "$(eval_gettext "Good, but you took \$nb_seconds seconds. You needed to take less than \$MAX_DELAY seconds...")"
    return 1
  fi

  echo "$(eval_gettext "Perfect, it took you only \$nb_seconds seconds to complete this mission!")"
  return 0
)

_mission_check
