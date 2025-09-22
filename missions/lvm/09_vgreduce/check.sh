#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check /dev/esdebe/oljoliptichaaah is removed
    if danger sudo lvdisplay /dev/esdebe/oljoliptichaaah >/dev/null 2>&1; then
        echo "$(eval_gettext "Vous devez supprimer le village d'Oljoliptichaaah de la province d'Esdebe.")"
        return 1
    fi

    # Check esdebe VG have been reduced
    PV_COUNT=$(danger sudo vgdisplay esdebe | grep "PV Count" | awk '{print $3}')
    if [ "$PV_COUNT" -ne 1 ]; then
        echo "$(eval_gettext "Vous devez séparer la province d'Esdebe et d'Esdece.")"
        return 1
    fi

    # Check /dev/gsh_sdc is no longer a physical volume
    if danger sudo pvdisplay "/dev/gsh_sdc" >/dev/null 2>&1; then
        echo "$(eval_gettext "Vous devez renvoyer la province d'Esdece dans la dimension éthérique.")"
        return 1
    fi

    echo "$(eval_gettext "Bravo, Oljoliptichaaah a été rayé de la carte et la province d'Esdece renvoyée dans la dimension éthérique ! \
    Cela devrait éviter que les sujets du roi ne soient dévorés par des félins trop gloutons, et plus important, que le personnel de la LVM ne doivent remplir les papiers relatifs à ces disparitions.")"

    return 0
)

_mission_check
