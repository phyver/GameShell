#!/bin/sh

. alt_history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
xeyes &
add_cmd gsh check
gsh check

. alt_history_stop.sh
