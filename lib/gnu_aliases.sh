#!/bin/bash

function REALPATH() {
    readlink -f "$@"
}
export -f REALPATH

function GET_MTIME() {
    stat -c %y "$@"
}
export -f GET_MTIME
