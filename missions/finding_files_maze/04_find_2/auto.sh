#!/usr/bin/env sh

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -type f | xargs grep -l "$(gettext "ruby")" | xargs -I"{}" mv "{}" "$GSH_CHEST"
)
gsh check
