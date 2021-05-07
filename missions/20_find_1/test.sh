gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/.Maze')" -iname "*$(gettext "gold_coin")*" -type f -print0 | xargs -0 rm -rf
gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/.Maze')" -iname "*$(gettext "gold_coin")*" -type f -print0 | xargs -0 rm -rf
echo "coin" > "$(eval_gettext '$GSH_HOME/Garden/.Maze')/gold_coin"
gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/.Maze')" -iname "*$(gettext "gold_coin")*" -type f -print0 | xargs -0 mv -t "$GSH_CHEST"
gsh assert check true
