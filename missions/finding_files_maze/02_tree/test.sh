#!/usr/bin/env sh

gsh assert check false

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"

  find . -name "*$(gettext "silver_coin")*" -type f | xargs rm -rf
  gsh assert check false

  find . -name "*$(gettext "silver_coin")*" -type f | xargs rm -rf
  echo "coin" > "$(eval_gettext '$GSH_HOME/Garden/Maze')/silver_coin"
  gsh assert check false

  find . -name "*$(gettext "silver_coin")*" -type f -exec mv "{}" "$GSH_CHEST" \;
  gsh assert check true
)
