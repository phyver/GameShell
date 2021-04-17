BURROW="$(eval_gettext "\$GASH_HOME/Castle/Cellar")/.$(gettext "Burrow")"

S1=$(command ls "$BURROW" | checksum)
S2=$(cat "$GASH_TMP/cats")

if [ "$S1" = "$S2" ]
then
  rm -f "$GASH_TMP/cats"
  unset BURROW S1 S2
  true
else
  rm -f "$GASH_TMP/cats"
  rm -f "$BURROW"/*
  unset BURROW S1 S2
  false
fi
