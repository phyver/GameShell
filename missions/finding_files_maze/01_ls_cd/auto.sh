#!/usr/bin/env sh

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -name "*_$(gettext "copper_coin")_*" -type f -exec mv "{}" "$GSH_CHEST" \;
)
gsh check
