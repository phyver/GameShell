#!/bin/bash

function REALPATH() {
  local TARGET="$1"
  [ -f "$TARGET" ] || [ -d "$TARGET" ] || return 1 #no nofile

  while [ -L "$TARGET" ]; do
    TARGET="$(readlink "$TARGET")"
  done
  echo "$TARGET"
}
export -f REALPATH

function GET_MTIME() {
    stat -f %S%m "$@"
}
export -f GET_MTIME
