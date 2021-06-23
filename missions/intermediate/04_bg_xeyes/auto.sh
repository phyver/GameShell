#!/bin/sh

. history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
xeyes &
add_cmd gsh check
gsh check

. history_clean.sh
