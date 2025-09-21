#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check that the volume group "usa" exists
    if ! danger sudo vgdisplay usa >/dev/null 2>&1; then
        echo "Vous devez renommer la province d'Esdea en USA."
        return 1
    fi

    if danger sudo vgdisplay esdea >/dev/null 2>&1; then
        echo "Vous devez supprimer la province d'Esdea seule la province d'USA doit exister."
        return 1
    fi

    if danger sudo vgdisplay esdebe >/dev/null 2>&1; then
        echo "Vous devez rattacher la province d'Esdebe à la province d'USA."
        return 1
    fi

    # Check that the volume group "usa" contains both logical volumes
    if ! danger sudo lvs usa/douskelpar >/dev/null 2>&1; then
        echo "Le village Douskelpar doit être dans la nouvelle province d'USA."
        return 1
    fi
    if ! danger sudo lvs usa/ouskelcoule >/dev/null 2>&1; then
        echo "Le village Ouskelcoule doit être dans la nouvelle province d'USA."
        return 1
    fi
    if ! danger sudo lvs usa/grandflac >/dev/null 2>&1; then
        echo "Le village Grandflac doit être dans la nouvelle province d'USA."
        return 1
    fi

    echo "Bravo ! Vous avez réussi à rattacher les colonies d'Esdea et d'Esdebe en une nouvelle province autonome, les USA !"

    return 0
)

_mission_check
