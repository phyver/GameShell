#!/usr/bin/env sh

source "$MISSION_DIR/../00_shared/utils.sh"

# Do nothing we need to keep the loop devices and the disk images
# for the next missions in the LVM series.

lvm_cleanup "07" 
return $?
