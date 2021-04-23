#!/bin/bash

# la version de "readlink" de macOS n'a pas l'option "-f", il faut utiliser
# "greadlink" qui fait partie de "coreutils"
function REALPATH() {
    greadlink -f "$@"
}
export -f REALPATH

function GET_MTIME() {
    gstat -c %y "$@"
}
export -f GET_MTIME
