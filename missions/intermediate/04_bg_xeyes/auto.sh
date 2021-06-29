#!/bin/sh

. alt_history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
xeyes &
gsh check

. alt_history_stop.sh
