gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" | xargs -0 rm
gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" | xargs -0 rm
echo "diamond" > "$(eval_gettext '$GSH_HOME/Garden/Maze')/12345"
gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" | xargs -0 mv -t "$GSH_CHEST"
gsh assert check true
