killall -q cat-generator
gash assert check false

killall -q cat-generator
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gash assert check false

sleep 1
killall -q cat-generator
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
gash assert check false MSG

killall -q cat-generator
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
gash assert check true

killall -q cat-generator
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")/$(gettext "piece_of_cheese")"
gash assert check false

killall -q cat-generator
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/.*_"$(gettext "wind-up_cat")"
rm -f "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")"/*_"$(gettext "wind-up_cat")"
sed -i "1d" "$(eval_gettext '$GASH_HOME/Castle/Kitchen')/$(gettext "Pantry")/$(gettext "barrel_of_apples")"
gash assert check false
