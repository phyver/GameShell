#!/bin/sh

. history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
xeyes &
gsh check

. history_clean.sh
