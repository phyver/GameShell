#!/bin/bash

function REALPATH() {
    readlink -f "$@"
}
export -f REALPATH

function PAGER() {
    if command -v less &> /dev/null
    then
        less -REX "$@"
    else
        more -d "$@"
    fi
}
export -f PAGER

function GET_MTIME() {
    stat -c %y "$@"
}
export -f GET_MTIME
