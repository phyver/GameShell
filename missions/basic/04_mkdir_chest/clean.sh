#!/bin/sh

case $GSH_LAST_ACTION in
  check_true)
    :
    ;;
  *)
    find "$GSH_HOME" -iname "$(gettext "Hut")" -print0 | xargs -0 rm -rf
    find "$GSH_HOME" -iname "$(gettext "Chest")" -print0 | xargs -0 rm -rf
    ;;
esac

