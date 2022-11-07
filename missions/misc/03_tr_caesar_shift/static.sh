#!/usr/bin/env sh

mkdir -p "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office/Drawer')"
sign_file "$MISSION_DIR/ascii-art/ink_scroll.txt" "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office/Drawer')/$(gettext "ink_and_scroll")"
