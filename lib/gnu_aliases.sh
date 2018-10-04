#/bin/bash

function CANNONICAL_PATH() {
    readlink -f "$@"
}
export -f CANNONICAL_PATH

function GET_MTIME() {
    stat -c %y "$@"
}
export -f GET_MTIME
