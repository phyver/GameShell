#!/bin/sh

. alt_history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
xeyes &
add_cmd gsh check
( sleep 1; kill -9 $(ps | grep xeyes | awk '{print $1}') 2>/dev/null )&
gsh check

. alt_history_stop.sh
