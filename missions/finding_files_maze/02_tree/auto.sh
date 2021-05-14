find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -name "*$(gettext "silver_coin")*" -type f -print0 | xargs -0 mv -t $GSH_CHEST
gsh check
