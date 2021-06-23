#!/bin/bash

. history_start.sh

add_cmd "xeyes"
add_cmd "xeyes &"
gsh assert check false

add_cmd "xeyes"
add_cmd "xeyes &"
add_cmd "something1"
add_cmd "something2"
add_cmd "something3"
add_cmd "something4"
gsh assert check false

add_cmd "xeyes &"
add_cmd "xeyes"
gsh assert check false

xeyes &
add_cmd "xeyes &"
add_cmd "xeyes"
gsh assert check true

ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null

. history_clean.sh

