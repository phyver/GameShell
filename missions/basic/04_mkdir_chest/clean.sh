#!/bin/sh

case $GSH_LAST_ACTION in
  check_true)
    :
    ;;
  *)
    case "$(pwd)" in
      "$GSH_HOME"/*)
        if echo "${PWD#$GSH_HOME/}" | grep -Eq "$(gettext "Hut")|$(gettext "Chest")"
        then
          cd "$GSH_HOME"
          echo "$(gettext "You are back at the initial directory.")"
        fi
        ;;
    esac
    find "$GSH_HOME" -iname "$(gettext "Hut")" -print0 | xargs -0 rm -rf
    find "$GSH_HOME" -iname "$(gettext "Chest")" -print0 | xargs -0 rm -rf
    ;;
esac

