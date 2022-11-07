#!/usr/bin/env sh

cp "$MISSION_DIR/ascii-art/diamond.txt" ./".$(gettext "nice_rock")"
cat "$(eval_gettext '$MISSION_DIR/goal/en.txt')"

