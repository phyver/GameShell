#!/bin/sh

[ -z "$GSH_CHEST" ] && GSH_CHEST="$(eval_gettext '$GSH_HOME/Forest/Hut/Chest')"
mkdir -p "$GSH_CHEST"

_mission_check() (
  GREAT_HALL="$(eval_gettext '$GSH_HOME/Castle/Great_hall')"

  temp=$(mktemp)
  command ls "$GREAT_HALL" | sort >"$temp"
  if ! cmp -s "$GSH_TMP/great_hall_contents" "$temp"
  then
    echo "$(gettext "You changed the contents of the great hall!")"
    rm -f "$temp"
    return 1
  fi
  rm -f "$temp"

  if command ls "$GSH_CHEST" | grep -Eq "$(gettext "decorative_shield")|$(gettext "suit_of_armour")_$(gettext "stag_head")"
  then
    echo "$(gettext "I only wanted the standards!")"
    return 1
  fi

  temp1=$(mktemp)
  temp2=$(mktemp)
  grep "$(gettext "standard")" "$GSH_TMP/great_hall_contents" >"$temp1"
  command ls "$GSH_CHEST" | sort | grep "$(gettext "standard")" >"$temp2"
  if ! cmp -s "$temp1" "$temp2"
  then
    rm -f "$temp1" "$temp2"
    echo "$(gettext "I wanted all the standards!")"
    return 1
  fi
  rm -f "$temp1" "$temp2"
  return 0
)

_mission_check
