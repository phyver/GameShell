# find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -name "$(gettext "copper_coin")" -type f -print0 | xargs -0 mv -t "$GSH_CHEST"
find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -name "*_$(gettext "copper_coin")_*" -type f -exec mv {} "$GSH_CHEST" \;
gsh check
