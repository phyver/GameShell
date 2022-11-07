#!/usr/bin/env sh

# protect the root directory
[ "$GSH_MODE" != "DEBUG" ] && ! [ -d "$GSH_ROOT/.git" ] && gsh protect

. "$MISSION_DIR/../00_shared/clean.sh"
rm -f "$GSH_TMP/copper_coin"
