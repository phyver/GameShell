gash assert check false

find "$(eval_gettext '$GASH_HOME/Garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "ruby")" | xargs -0 rm
gash assert check false

find "$(eval_gettext '$GASH_HOME/Garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "ruby")" | xargs -0 rm
echo "ruby" > "$(eval_gettext '$GASH_HOME/Garden/.Maze')/12345"
gash assert check false

find "$(eval_gettext '$GASH_HOME/Garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "ruby")" | xargs -0 mv -t "$GASH_CHEST"
gash assert check true
