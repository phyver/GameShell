#!/bin/bash

case "$GSH_LAST_ACTION" in
  "check_true")
    ;;
  *)
    unalias journal 2>/dev/null
    unset EDITOR
    ;;
esac
