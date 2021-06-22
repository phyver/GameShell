#!/bin/bash

# function cannot be in a subshell because it needs access to aliases defined
# in the main shell.

_mission_check() {
  local cmd
  cmd=$(alias "$(gettext "journal")" 2>/dev/null | cut -f2 -d"=" | tr -d "'")
  if [ -z "$cmd" ]
  then
    local alias_name=$(gettext "journal")
    echo "$(eval_gettext "No alias '\$alias_name' has been found...")"
    return 1
  fi

  EDITOR=${EDITOR:-nano}
  cmd=$(echo "$cmd" | sed "s/\\\$EDITOR/$EDITOR/g")

  case "$cmd" in
    *$EDITOR*)
      # "cd /" to detect
      # alias journal="nano journal.txt"
      # used from the Chest
      local target_path
      target_path="$(cd / ; eval "${cmd/$EDITOR/realpath}" 2>/dev/null)"
      if [ "$target_path" = "$(realpath "$GSH_CHEST/$(gettext "journal").txt" 2>/dev/null)" ]
      then
        return 0
      else
        target_path="${cmd// *$EDITOR */}"
        echo "$(eval_gettext "It seems you alias doesn't refer to the appropriate file (\$target_path).
Make sure to use an absolute path...")"
        find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
        return 1
      fi

      ;;
    *)
      echo "$(eval_gettext "Your alias doesn't use the command '\$EDITOR'...")"
      find "$GSH_HOME" -iname "*$(gettext "journal")*" -print0 | xargs -0 rm -rf
      return 1
      ;;
  esac
}

_mission_check
