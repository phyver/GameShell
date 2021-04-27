find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -iname "*$(gettext "coin")*" -type f -print0 | xargs -0 mv -t $GASH_CHEST
gash check
