#!/bin/bash

# la version de "readlink" de macOS n'a pas l'option "-f", il faut utiliser
# "greadlink" qui fait partie de "coreutils"
function CANONICAL_PATH() {
    greadlink -f "$@"
}
export -f CANONICAL_PATH

function GET_MTIME() {
    gstat -c %y "$@"
}
export -f GET_MTIME
