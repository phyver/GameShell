#!/bin/sh

cd
gsh assert check false


lair="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name ".$(gettext "Lair_of_the_spider_queen")*")"
cd "$lair"
gsh assert check false
unset lair


lair="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name ".$(gettext "Lair_of_the_spider_queen")*")"
cd "$lair"
queen=$(find "$lair" -type f -name "*$(gettext "spider_queen")*")
rm -f "$queen"
gsh assert check true
unset lair queen


lair="$(find "$(eval_gettext '$GSH_HOME/Castle/Cellar')" -type d -name ".$(gettext "Lair_of_the_spider_queen")*")"
cd "$lair"
bat=$(find "$lair" -type f -name "*$(gettext "baby_bat")*")
rm -f "$bat"
gsh assert check false
unset lair bat
