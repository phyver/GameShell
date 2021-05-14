#!/bin/bash

_init_mission() {
    local CELLAR=$(eval_gettext "\$GSH_HOME/Castle/Cellar")
    mkdir -p "$CELLAR"
    rm -f "$CELLAR"/.??*

    local I
    for I in $(seq 100)
    do
        local spider=${CELLAR}/.${RANDOM}_${I}_$(gettext "spider")
        sign_file "$MISSION_DIR/ascii-art/spider-$((RANDOM%3)).txt" "$spider"
        if [ "$((I%5))" -eq 0 ]
        then
            echo -n "."
        fi
    done

    for I in $(seq 10)
    do
        local bat=${CELLAR}/.${RANDOM}_${I}_$(gettext "bat")
        sign_file "$MISSION_DIR/ascii-art/bat-$((RANDOM%3)).txt" "$bat"
        if [ "$((I%5))" -eq 0 ]
        then
            echo -n "."
        fi
    done

    find "$CELLAR" -maxdepth 1 -name ".*$(gettext "bat")" | sort | checksum > "$GSH_VAR/bats"
}
_init_mission | progress_bar
