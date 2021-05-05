#!/bin/bash

[ -z "$GASH_CHEST" ] && GASH_CHEST="$(eval_gettext '$GASH_HOME/Forest/Hut/Chest')"
mkdir -p "$GASH_CHEST"
