#!/usr/bin/env sh

_mission_check() {
  r=$(cat "$GSH_TMP/control-C")
  printf "%s " "$(gettext "What's a valid 4 letters sequence?")"
  read -r n

  case "$r" in
    *[!a-zA-Z]*)
      return 1
      ;;
    ????)
      if [ "$n" = "$r" ]
      then
        return 0
      else
        return 1
      fi
      ;;
    *)
      return 1
  esac
}
_mission_check
