#!/bin/bash

# la version de "readlink" de macOS n'a pas l'option "-f", il faut utiliser
# "greadlink" qui fait partie de "coreutils"
function REALPATH() {
    greadlink -f "$@"
}
export -f REALPATH

function PAGER() {
    if [ -n "$PAGER" ]
    then
        $PAGER "$@"
    elif command -v less 2> /dev/null
    then
        less -EX "$@"
    else
        more "$@"
    fi
}
export -f PAGER

function GET_MTIME() {
    gstat -c %y "$@"
}
export -f GET_MTIME
