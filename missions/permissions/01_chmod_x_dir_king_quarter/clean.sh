#!/bin/bash

king_quarter=$(eval_gettext '$GSH_HOME/Castle/Main_building/Throne_room/Kings_quarter')

case "$GSH_LAST_ACTION" in
  "check_true")
    :
    ;;
  *)
    _PWD="$(realpath $(pwd) 2>/dev/null)"
    if [ -n "$_PWD" ] && [ "$_PWD" = "$(realpath "$king_quarter" 2>/dev/null)" ]
    then
      cd ..
    fi
    unset _PWD
    ;;
esac

# avoid problems when making a tar archive
chmod +x "$king_quarter"
unset king_quarter
