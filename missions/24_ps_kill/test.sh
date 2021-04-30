ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
gash assert check false

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gash assert check false

sleep 1
ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
gash assert check false MSG

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gash assert check true

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")/$(gettext "piece_of_cheese")"
gash assert check false

ps -e | awk '/cat-generator/ {print $1}' | xargs kill -9 2> /dev/null
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
sed -i "1d" "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")/$(gettext "barrel_of_apples")"
gash assert check false
