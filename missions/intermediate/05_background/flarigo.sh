#!/bin/sh

. gsh_gettext.sh

command=$(gettext "flarigo")


file="$MISSION_DIR/ascii-art/f$((1 + $(RANDOM)%6))"
indent=$(echo "                                       " | head -c "$((2 + 4 * ($(RANDOM)%8)))")

rm -f "$GSH_TMP/flarigo.pids"
for i in $(seq $((5 + $(RANDOM)%5)))
do
  echo "$indent    *"
  sleep 0.1
done

awk -v indent="$indent" '{print indent, $0}' < "$file"

echo $$ >> "$GSH_TMP/flarigo.pids"

sleep 1

exit 0
