find "$(eval_gettext '$GASH_HOME/Garden/.Maze')" -name "$(gettext "copper_coin")" -type f -print0 | xargs -0 mv -t "$GASH_CHEST"
gash check
