# find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" |  xargs -0 mv -t "$GSH_CHEST"
find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" |  xargs -0 -I"{}" mv "{}" "$GSH_CHEST"
gsh check
