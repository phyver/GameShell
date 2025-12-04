#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check that the volume group "usa" is exported
    if danger sudo vgs -o vg_name,vgexported --noheadings | grep -q "^ *usa *exported"; then
        echo "$(eval_gettext "Bravo, la république fédérale des USA est prête pour son \"changement de disque\" comme disent les géo-manciens !")"
        return 0
    else
        echo "$(eval_gettext "Vous devez préparer la république fédérale des USA pour sécuriser sa téléportation astrale !")"
        return 1
    fi
)

_mission_check
