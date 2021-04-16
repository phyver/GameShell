D=$(date +%s)

for I in $(seq 3)
do
  C="$(gettext "coin")_$I"
  S=$(checksum "$C#$D")
  echo "$C#$D $S" > "$(eval_gettext "\$GASH_HOME/Castle/Cellar")/$C"
done

unset DATE D I C S
