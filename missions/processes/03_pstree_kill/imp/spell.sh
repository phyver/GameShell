#!/usr/bin/env sh

. gsh_gettext.sh

DELAY=3
OFFSET=$1

sleep "${OFFSET:-1}"
while true
do
  filename="$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(RANDOM)_$(gettext "coal")"
  sign_file "$MISSION_DIR/ascii-art/coal-$(($(RANDOM)%4)).txt" "$filename"
  echo "${filename#$(eval_gettext '$GSH_HOME/Castle/Cellar')/}" >> "$GSH_TMP/coals.list"
  sleep $DELAY & wait $!
done

