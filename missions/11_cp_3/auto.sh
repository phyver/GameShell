mkdir -p "$GASH_CHEST"

filename=$(head -n1 "$GASH_TMP/painting")

cp "$(eval_gettext '$GASH_HOME/Castle/Dungeon/First_floor')/$filename" "$GASH_CHEST"

gash check

unset filename
