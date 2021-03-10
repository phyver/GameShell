#!/bin/bash

export NATURE=chat

"$GASH_LOCAL_BIN"/chat.sh &
disown
"$GASH_LOCAL_BIN"/chat.sh &
disown
"$GASH_LOCAL_BIN"/chat.sh &
disown

unset NATURE
trap "" SIGTERM SIGINT
tail -f /dev/null
