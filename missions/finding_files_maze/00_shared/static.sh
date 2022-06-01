#!/bin/sh

mkdir -p "$(eval_gettext '$GSH_HOME/Garden/Maze')"
mkdir -p "$(eval_gettext '$GSH_HOME/Garden/Flower_garden')"
mkdir -p "$(eval_gettext '$GSH_HOME/Garden/Shed')"

sign_file "$MISSION_DIR/ascii-art/bucket.txt" "$(eval_gettext '$GSH_HOME/Garden/Shed')/$(gettext "secchio")"
sign_file "$MISSION_DIR/ascii-art/flowers.txt" "$(eval_gettext '$GSH_HOME/Garden/Flower_garden')/$(gettext "fiori")"
sign_file "$MISSION_DIR/ascii-art/wheelbarrow.txt" "$(eval_gettext '$GSH_HOME/Garden/Shed')/$(gettext "carriola")"

