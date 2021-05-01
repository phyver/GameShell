find "$(eval_gettext '$GASH_HOME/Garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "ruby")" |  xargs -0 mv -t "$GASH_CHEST"
gash check
