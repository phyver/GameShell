#!/usr/bin/env sh

. gsh_gettext.sh

DELAY=3
OFFSET=$1

sleep "${OFFSET:-1}"
while true
do
  filename="$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(RANDOM)_$(gettext "snowflake")"
  sign_file "$MISSION_DIR/ascii-art/snowflake-$(($(RANDOM)%4)).txt" "$filename"
  echo "${filename#$(eval_gettext '$GSH_HOME/Castle/Cellar')/}" >> "$GSH_TMP/snowflakes.list"
  sleep $DELAY & wait $!
done

