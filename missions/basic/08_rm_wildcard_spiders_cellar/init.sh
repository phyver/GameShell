#!/bin/bash

_mission_init() {
    local CELLAR=$(eval_gettext "\$GSH_HOME/Castle/Cellar")
    mkdir -p "$CELLAR"
    rm -f "$CELLAR"/*_"$(gettext "spider")"_*

    local I
    for I in $(seq 100)
    do
        local spider=${CELLAR}/${RANDOM}_$(gettext "spider")_$I
        sign_file "$MISSION_DIR/ascii-art/spider-$((RANDOM%3)).txt" "$spider"
        if [ "$((I%5))" -eq 0 ]
        then
            echo -n "."
        fi
    done

    for I in $(seq 5)
    do
        local bat=${CELLAR}/${RANDOM}_$(gettext "bat")_$I
        sign_file "$MISSION_DIR/ascii-art/bat-$((RANDOM%3)).txt" "$bat"
        if [ "$((I%5))" -eq 0 ]
        then
            echo -n "."
        fi
    done

    find "$CELLAR" -maxdepth 1 -name "*_$(gettext "bat")_*" | sort | checksum > "$GSH_VAR/bats"
}
_mission_init | progress_bar
