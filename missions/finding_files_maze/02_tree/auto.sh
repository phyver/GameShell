#!/bin/sh

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -name "*$(gettext "silver_coin")*" -type f -exec mv "{}" "$GSH_CHEST" \;
)
gsh check
