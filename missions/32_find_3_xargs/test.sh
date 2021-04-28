gash assert check false

find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" | xargs -0 rm
gash assert check false

find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" | xargs -0 rm
echo "diamond" > "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')/12345"
gash assert check false

find "$(eval_gettext '$GASH_HOME/Botanical_garden/.Maze')" -type f -print0 | xargs -0 grep -Zl "$(gettext "diamond")" | xargs -0 mv -t "$GASH_CHEST"
gash assert check true
