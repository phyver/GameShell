#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check that the volume group "usa" is exported
    if danger sudo vgs -o vg_name,vgexported --noheadings | grep -q "^ *usa *exported"; then
        echo "$(eval_gettext "Bravo, the federal republic of USA is ready for its ''disk change'' as the geo-mancers say!")"
        return 0
    else
        echo "$(eval_gettext "You must prepare the federal republic of USA to secure its astral teleportation!")"
        return 1
    fi
)

_mission_check
