#!/bin/bash

. alt_history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
add_cmd gsh check
gsh assert check false

add_cmd "xeyes"
add_cmd "xeyes &"
add_cmd "something1"
add_cmd "something2"
add_cmd "something3"
add_cmd "something4"
add_cmd gsh check
gsh assert check false

add_cmd "xeyes &"
add_cmd "xeyes"
add_cmd gsh check
gsh assert check false

xeyes &
add_cmd "xeyes &"
add_cmd "xeyes"
add_cmd gsh check
gsh assert check true

ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null

. alt_history_stop.sh

