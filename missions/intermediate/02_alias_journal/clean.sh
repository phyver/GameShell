#!/bin/bash

case "$GSH_LAST_ACTION" in
  "check_true")
    ;;
  *)
    unalias journal
    unset EDITOR
    ;;
esac
