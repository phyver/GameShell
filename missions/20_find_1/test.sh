gash assert check false

find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -iname "*$(gettext "gold_coin")*" -type f -print0 | xargs -0 rm -rf
gash assert check false

find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -iname "*$(gettext "gold_coin")*" -type f -print0 | xargs -0 rm -rf
echo "coin" > "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')/gold_coin"
gash assert check false

find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -iname "*$(gettext "gold_coin")*" -type f -print0 | xargs -0 mv -t "$GASH_CHEST"
gash assert check true
