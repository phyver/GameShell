#!/bin/bash

export NATURE="chat"
$GASH_BIN/chat.sh &
disown
unset NATURE
