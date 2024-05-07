#!/usr/bin/env sh

_mission_check() {
  r=$(cat "$GSH_TMP/control-C")
  printf "%s " "$(gettext "What's the fireworks incantation?")"
  read -r n

  case "$r" in
    "" | *[!0-9]*)
      if [ "$n" = "$r" ]
      then
        cat "$MISSION_DIR/ascii-art/fireworks.txt"
        return 0
      else
        cat "$MISSION_DIR/ascii-art/explosion.txt"
        return 1
      fi
      ;;
    *)
      cat "$MISSION_DIR/ascii-art/explosion.txt"
      return 1
  esac
}
_mission_check
