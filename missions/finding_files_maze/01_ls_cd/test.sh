gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -name "*_$(gettext "copper_coin")_*" -type f -print0 | xargs -0 rm -rf
gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -name "*_$(gettext "copper_coin")_*" -type f -print0 | xargs -0 rm -rf
echo "coin" > "$(eval_gettext '$GSH_HOME/Garden/Maze')/copper_coin"
gsh assert check false

find "$(eval_gettext '$GSH_HOME/Garden/Maze')" -name "*_$(gettext "copper_coin")_*" -type f -exec mv {} "$GSH_CHEST" \;
gsh assert check true
