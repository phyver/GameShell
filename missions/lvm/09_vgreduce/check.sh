#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check /dev/esdebe/oljoliptichaaah is removed
    if danger sudo lvdisplay /dev/esdebe/oljoliptichaaah >/dev/null 2>&1; then
        echo "$(eval_gettext "You must remove the village of Oljoliptichaaah from the province of Esdebe.")"
        return 1
    fi

    # Check esdebe VG have been reduced
    PV_COUNT=$(danger sudo vgdisplay esdebe | grep "PV Count" | awk '{print $3}')
    if [ "$PV_COUNT" -ne 1 ]; then
        echo "$(eval_gettext "You must separate the provinces of Esdebe and Esdece.")"
        return 1
    fi

    # Check /dev/gsh_sdc is no longer a physical volume
    if danger sudo pvdisplay "/dev/gsh_sdc" >/dev/null 2>&1; then
        echo "$(eval_gettext "You must return the province of Esdece to the ethereal dimension.")"
        return 1
    fi

    echo "$(eval_gettext "Bravo, Oljoliptichaaah has been erased from the map and the province of Esdece returned to the ethereal dimension! \
    This should prevent the king's subjects from being devoured by overly gluttonous felines, and more importantly, prevent LVM staff from having to fill out paperwork about these disappearances.")"

    return 0
)

_mission_check
