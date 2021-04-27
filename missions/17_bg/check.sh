#!/bin/bash

# turn history on (off by default for non-interactive shells
HISTFILE=$GASH_DATA/history

if ! (fc -nl -4 | grep -qx "[[:blank:]]*xeyes[[:blank:]]*")
then
    echo "$(gettext "You haven't run the 'xeyes' command directly.")"
    killall -q -9 xeyes
    false
elif ! LC_MESSAGES=C jobs | grep "xeyes.*&" | grep -qi running
then
    echo "$(gettext "There doesn't seem to be an 'xeyes' process running.")"
    killall -q -9 xeyes
    false
else
    true
fi


