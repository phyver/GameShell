#!/bin/bash

function CANONICAL_PATH() {
    readlink -f "$@"
}
export -f CANONICAL_PATH

function GET_MTIME() {
    stat -c %y "$@"
}
export -f GET_MTIME
