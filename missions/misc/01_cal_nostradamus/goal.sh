#!/bin/sh

YYYY=$(cut -d"-" -f1 "$GSH_TMP"/date)
MM=$(cut -d"-" -f2 "$GSH_TMP"/date)
DD=$(cut -d"-" -f3 "$GSH_TMP"/date)
sed -e "s/\\\$YYYY/$YYYY/g" \
    -e "s/\\\$MM/$MM/g" \
    -e "s/\\\$DD/$DD/g" \
    "$(eval_gettext '$MISSION_DIR/goal/en.txt')"
unset YYYY MM DD
