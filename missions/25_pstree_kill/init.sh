#!/bin/bash

"$GASH_LOCAL_BIN/felix.sh" &
disown
"$GASH_LOCAL_BIN/gros_minet.sh" &
disown

