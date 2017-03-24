#!/bin/bash

export NATURE=fromage

$GASH_LOCAL_BIN/chat.sh &
disown
$GASH_LOCAL_BIN/chat.sh &
disown
$GASH_LOCAL_BIN/chat.sh &
disown

unset NATURE
trap "" SIGTERM SIGSTOP SIGINT
tail -f /dev/null
