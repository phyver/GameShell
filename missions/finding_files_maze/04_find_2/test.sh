#!/bin/sh

gsh assert check false

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -type f -print0 | xargs -0 grep -l "$(gettext "rubino")" | xargs rm
  gsh assert check false
)

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -type f -print0 | xargs -0 grep -l "$(gettext "rubino")" | xargs rm
  echo "rubino" > "$(eval_gettext '$GSH_HOME/Garden/Maze')/12345"
  gsh assert check false
)

(
  cd "$(eval_gettext '$GSH_HOME/Garden/Maze')"
  find . -type f -print0 | xargs -0 grep -l "$(gettext "rubino")" | xargs -I"{}" mv "{}" "$GSH_CHEST"
  gsh assert check true
)
