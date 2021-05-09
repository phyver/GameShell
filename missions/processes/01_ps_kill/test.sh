ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
gsh assert check false

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gsh assert check false

sleep 1
ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
gsh assert check false MSG

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gsh assert check true

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")/$(gettext "piece_of_cheese")"
gsh assert check false

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
sed -i "1d" "$(eval_gettext '$GSH_HOME/Castle/Kitchen')/$(gettext "Pantry")/$(gettext "barrel_of_apples")"
gsh assert check false
