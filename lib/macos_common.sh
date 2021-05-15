#!/usr/bin/env bash

# la version de "readlink" de macOS n'a pas l'option "-f", il faut utiliser
# "greadlink" qui fait partie de "coreutils"
function REALPATH() {
    greadlink -f "$@"
}
export -f REALPATH

function PAGER() {
    if command -v less &> /dev/null
    then
        less -rEX "$@"
    else
        more "$@"
    fi
}
export -f PAGER

# computes a CHECKSUM of a string
# with no argument, reads the string from STDIN
CHECKSUM() {
    if [ "$#" -eq 0 ]
    then
        sha1sum | cut -c 1-40
    else
        echo -n "$@" | sha1sum | cut -c 1-40
    fi
}
export -f CHECKSUM

SED-i() {
    sed -i '' "$@"
}
export -f SED-i

function GET_MTIME() {
    gstat -c %y "$@"
}
export -f GET_MTIME
