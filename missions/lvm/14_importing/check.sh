#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check if usa VG exists and is active
    if ! danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "usa"; then
        echo "$(eval_gettext "You must unfreeze the federal republic of USA, astral teleportation is canceled!")"
        return 1
    fi

    # Check that all mount points exists
    VILLAGES=(
        "Ouskelcoule"
        "Douskelpar"
        "Grandflac"
    )
    for VILLAGE in "${VILLAGES[@]}"; do
        MOUNT_POINT="$GSH_HOME/USA/$VILLAGE"
        if ! [ -d "$MOUNT_POINT" ]; then
            echo "$(eval_gettext "You must recreate the route between the kingdom and the village of \$VILLAGE, which does not exist!")"
            return 1
        fi

        if ! mountpoint -q "$MOUNT_POINT"; then
            echo "$(eval_gettext "You must reopen the route between the kingdom and the village of \$VILLAGE!")"
            return 1
        fi
    done

    echo "$(eval_gettext "Bravo, the federal republic of USA is again connected to the kingdom, no longer as a vassal, but as a federal and autonomous republic!")"

    return 0
)

_mission_check
