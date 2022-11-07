#!/usr/bin/env sh

(
  gsh assert check false
)

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -name "*_$(gettext "copper_coin")_*" -type f | xargs rm -rf
  gsh assert check false
)

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -name "*_$(gettext "copper_coin")_*" -type f | xargs rm -rf
  echo "coin" > "$(eval_gettext '$GSH_HOME/Garden/Maze')/copper_coin"
  gsh assert check false
)

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -name "*_$(gettext "copper_coin")_*" -type f -exec mv "{}" "$GSH_CHEST" \;
  gsh assert check true
)

