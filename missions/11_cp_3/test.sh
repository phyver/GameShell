mkdir -p $GASH_CHEST

gash assert check false

cp "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')/$(gettext "painting")_"* "$GASH_CHEST"
gash assert check false

gash assert '[ "$(find "$GASH_HOME" -name "'$(gettext "painting")'_*" | wc -l)" -eq 3 ]'

