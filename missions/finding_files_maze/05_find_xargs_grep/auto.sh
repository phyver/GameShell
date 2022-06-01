#!/bin/sh

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -type f | xargs grep -l "$(gettext "diamante")" | xargs -I"{}" mv "{}" "$GSH_CHEST"
)
gsh check
