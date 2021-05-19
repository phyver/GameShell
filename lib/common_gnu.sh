#!/bin/bash

function REALPATH() {
  readlink -f "$@"
}
export -f REALPATH

function PAGER() {
  if command -v less &> /dev/null
  then
    less -rEX "$@"
  else
    more -d "$@"
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
  sed -i "$@"
}
export -f SED-i
