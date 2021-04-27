filename=$(head -n1 "$GASH_MISSION_DATA/painting")

cp "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')/$filename" "$GASH_CHEST"

gash check

unset filename
