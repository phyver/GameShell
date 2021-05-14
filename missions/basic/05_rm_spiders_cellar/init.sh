#!/bin/bash

for i in $(seq 3)
do
    spider=$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "spider")$i
    sign_file "$MISSION_DIR/ascii-art/spider-$((RANDOM%3)).txt" "$spider"
done
unset spider

for i in $(seq 2)
do
    bat=$(eval_gettext '$GSH_HOME/Castle/Cellar')/$(gettext "bat")$i
    sign_file "$MISSION_DIR/ascii-art/bat-$((RANDOM%3)).txt" "$bat"
done
unset bat
