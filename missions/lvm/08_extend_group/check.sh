#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check $GSH_HOME/dev/sdc is a physical volume
    danger sudo pvdisplay "$GSH_HOME/dev/sdc" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$(eval_gettext "Vous devez incarner la province d'Esdece en tant que terre physique.")"
        return 1
    fi
    
    # Check $GSH_HOME/dev/sdc is part of esdebe VG
    danger sudo pvdisplay "$GSH_HOME/dev/sdc" | grep "esdebe" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$(eval_gettext "Vous devez ajouter la province d'Esdece à celle d'Esdebe.")"
        return 1
    fi

    # Check oljoliptichaaah LV exists
    danger sudo lvdisplay /dev/esdebe/oljoliptichaaah > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$(eval_gettext "Vous devez créer le village de Oljoliptichaaah.")"
        return 1
    fi

    # Check oljoliptichaaah LV size is 10M
    if ! check_lv_size esdebe/oljoliptichaaah 10; then
        echo "$(eval_gettext "Le village de Oljoliptichaaah doit faire 10 Mornifles (Mo).")"
        return 1
    fi
)

_mission_check
