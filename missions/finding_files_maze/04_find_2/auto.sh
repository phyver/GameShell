# find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "ruby")" |  xargs -0 mv -t "$GSH_CHEST"
find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -l "$(gettext "ruby")" | xargs -I"{}" mv "{}" "$GSH_CHEST"
gsh check
