#!/usr/bin/env sh

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -iname "*$(gettext "coin")*" -type f -exec mv "{}" "$GSH_CHEST" \;
)
gsh check
