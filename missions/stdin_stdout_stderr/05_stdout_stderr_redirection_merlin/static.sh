#!/bin/sh

mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Observatory')"
sign_file "$MISSION_DIR/ascii-art/moon.txt" "$(eval_gettext '$GSH_HOME/Castle/Observatory')/$(gettext "star_chart")"
