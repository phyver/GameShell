#!/bin/bash

export NATURE="chat"
$GASH_LOCAL_BIN/chat.sh &
disown
unset NATURE
