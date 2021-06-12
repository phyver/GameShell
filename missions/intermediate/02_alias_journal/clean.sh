#!/bin/sh

case "$GSH_LAST_ACTION" in
  "check_true")
    ;;
  *)
    unalias "$(gettext "journal")" 2>/dev/null
    unset EDITOR
    ;;
esac
