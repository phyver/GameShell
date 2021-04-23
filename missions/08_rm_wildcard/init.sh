BURROW="$(eval_gettext "\$GASH_HOME/Castle/Cellar")/.$(gettext "Burrow")"
mkdir -p "$BURROW"

D=$(date +%s)

for I in $(seq -w 10)
do
  S=$(checksum "$(gettext "cat")_${I}#${D}")
  touch "${BURROW}/${S}_$(gettext "CAT")"
done

for I in $(seq -w 100)
do
  S=$(checksum "$(gettext "rat")_${I}#${D}")
  touch "${BURROW}/${S}_$(gettext "rat")"
done

command ls "$BURROW" | grep ".*$(gettext "CAT")$" | sort | sha1sum | \
  cut -c 1-40 > "$GASH_MISSION_DATA/cats"

unset BURROW D I S
