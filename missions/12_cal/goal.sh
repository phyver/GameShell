#!/bin/bash

export YYYY=$(cut -d"-" -f1 "$GASH_TMP"/date)
export MM=$(cut -d"-" -f2 "$GASH_TMP"/date)
export DD=$(cut -d"-" -f3 "$GASH_TMP"/date)


envsubst '$YYYY $MM $DD' < "$(eval_gettext '$MISSION_DIR/goal/en.txt')"

unset YYYY MM DD
