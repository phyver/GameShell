#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check if usa VG exists and is active
    if ! danger sudo vgs --noheadings -o vg_name 2>/dev/null | awk '{print $1}' | grep -qx "usa"; then
        echo "Vous devez dégeler la république fédérale des USA, la téléportation astrale est annulée !"
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
            echo "Vous devez recréer la route entre le royaume et le village de $VILLAGE, qui n'existe pas !"
            return 1
        fi

        if ! mountpoint -q "$MOUNT_POINT"; then
            echo "Vous devez rouvrir la route entre le royaume et le village de $VILLAGE !"
            return 1
        fi
    done

    echo "Bravo, la république fédérale des USA est de nouveau connectée au royaume, non plus comme un vassale, mais une république fédérale et autonome !"

    return 0
)

_mission_check
