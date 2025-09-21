#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

# Do nothing we need to keep the loop devices and the disk images
# for the next missions in the LVM series.

if [ "$GSH_LAST_ACTION" != "check_false" ]; then
    lvm_cleanup "05"
    return $?
fi

return 0