#!/usr/bin/env sh

_mission_check() (
  if ! [ -f "$GSH_CHEST/$(gettext "crown")" ]
  then
    echo "$(gettext "There is no crown in your chest!")"
    return 1
  fi

  if ! [ -r "$GSH_CHEST/$(gettext "crown")" ]
  then
    echo "$(gettext "The crown in your chest is not readable!")"
    return 1
  fi

  if ! cmp -s "$GSH_CHEST/$(gettext "crown")" "$GSH_TMP/crown"
  then
    echo "$(gettext "The crown in your chest is a fake!")"
    return 1
  fi

  real_key=$(tail -n 1 "$GSH_TMP/crown" | cut -c 4-6)

  given_key=""
  while true
  do
    printf "%s " "$(gettext "What are the 3 digits inscribed on the base of the crown?")"
    read -r given_key
    case "$given_key" in
      "" | *[!0-9]*)
        :
        ;;
      *)
        break
        ;;
    esac
  done
  # don't check with '-ne' is it would accept non numerical answers!
  if [ "$real_key" != "$given_key" ]
  then
    echo "$(gettext "Those digits are not correct!")"
    return 1
  fi
  return 0
)

_mission_check
