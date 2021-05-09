lair="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name "$(gettext ".Lair_of_the_spider_queen")*")"
cd "$lair"
queen=$(find "$lair" -type f -name "*$(gettext "spider_queen")*")
rm -f "$queen"
unset lair queen
gsh check
