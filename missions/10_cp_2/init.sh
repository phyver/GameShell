ENTRANCE="$(eval_gettext "\$GASH_HOME/Castle/Entrance")"

D=$(date +%s)

for I in $(seq -w 5)
do
  for K in "$(gettext "garbage")" "$(gettext "gravel")" "$(gettext "hay")"
  do
    S=$(checksum "${K}_${I}#${D}")
    touch "${ENTRANCE}/${S}_${K}"
  done
done

for I in $(seq -w 10)
do
  K="$(gettext "ornament")"
  S=$(checksum "${K}_${I}#${D}")
  touch "${ENTRANCE}/${S}_${K}"
done

ls "$ENTRANCE" | sort > "$GASH_MISSION_DATA/entrance_contents"

unset ENTRANCE D I K S
