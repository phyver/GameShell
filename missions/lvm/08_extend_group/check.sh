#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

_mission_check() (
    # Check /dev/gsh_sdc is a physical volume
    danger sudo pvdisplay "/dev/gsh_sdc" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$(eval_gettext "You must incarnate the province of Esdece as physical land.")"
        return 1
    fi
    
    # Check /dev/gsh_sdc is part of esdebe VG
    danger sudo pvdisplay "/dev/gsh_sdc" | grep "esdebe" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$(eval_gettext "You must add the province of Esdece to Esdebe.")"
        return 1
    fi

    # Check oljoliptichaaah LV exists
    danger sudo lvdisplay /dev/esdebe/oljoliptichaaah > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "$(eval_gettext "You must create the village of Oljoliptichaaah.")"
        return 1
    fi

    # Check oljoliptichaaah LV size is 10M
    if ! check_lv_size esdebe/oljoliptichaaah 10; then
        echo "$(eval_gettext "The village of Oljoliptichaaah must be 10 Mornifles (MB).")"
        return 1
    fi
)

_mission_check
