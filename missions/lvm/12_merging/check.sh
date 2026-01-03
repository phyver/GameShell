#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check that the volume group "usa" exists
    if ! danger sudo vgdisplay usa >/dev/null 2>&1; then
        echo "$(eval_gettext "You must rename the province of Esdea to USA.")"
        return 1
    fi

    if danger sudo vgdisplay esdea >/dev/null 2>&1; then
        echo "$(eval_gettext "You must delete the province of Esdea, only the province of USA must exist.")"
        return 1
    fi

    if danger sudo vgdisplay esdebe >/dev/null 2>&1; then
        echo "$(eval_gettext "You must attach the province of Esdebe to the province of USA.")"
        return 1
    fi

    # Check that the volume group "usa" contains both logical volumes
    if ! danger sudo lvs usa/douskelpar >/dev/null 2>&1; then
        echo "$(eval_gettext "The village Douskelpar must be in the new province of USA.")"
        return 1
    fi
    if ! danger sudo lvs usa/ouskelcoule >/dev/null 2>&1; then
        echo "$(eval_gettext "The village Ouskelcoule must be in the new province of USA.")"
        return 1
    fi
    if ! danger sudo lvs usa/grandflac >/dev/null 2>&1; then
        echo "$(eval_gettext "The village Grandflac must be in the new province of USA.")"
        return 1
    fi

    echo "$(eval_gettext "Bravo! You have successfully attached the colonies of Esdea and Esdebe into a new autonomous province, the USA!")"

    return 0
)

_mission_check
