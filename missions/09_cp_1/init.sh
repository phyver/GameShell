ENTRANCE="$(eval_gettext "\$GASH_HOME/Castle/Entrance")"

D=$(date +%s)

for I in $(seq 4)
do
  F="$(gettext "standard")_${I}"
  S=$(checksum "${F}#${D}")
  echo "${F}#${D} ${S}" > "${ENTRANCE}/${F}"
done

unset ENTRANCE D I F S