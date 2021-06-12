#!/bin/sh

mkdir -p "$(eval_gettext '$GSH_HOME/Mountain/Cave')"
sign_file "$MISSION_DIR/ascii-art/cauldron.txt" "$(eval_gettext '$GSH_HOME/Mountain/Cave')/$(gettext "cauldron")"
