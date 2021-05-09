#!/bin/bash

# turn history on (off by default for non-interactive shells
HISTFILE=$GSH_CONFIG/history

if ! (fc -nl -4 | grep -qx "[[:blank:]]*xeyes[[:blank:]]*")
then
    echo "$(gettext "You haven't run the 'xeyes' command directly.")"
    ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null
    false
elif ! LC_MESSAGES=C jobs | grep "xeyes.*&" | grep -qi running
then
    echo "$(gettext "There doesn't seem to be an 'xeyes' process running.")"
    ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null
    false
else
    true
fi


