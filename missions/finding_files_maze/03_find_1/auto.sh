find "$(eval_gettext '$GSH_HOME/Garden/.Maze')" -iname "*$(gettext "coin")*" -type f -print0 | xargs -0 mv -t $GSH_CHEST
gsh check
