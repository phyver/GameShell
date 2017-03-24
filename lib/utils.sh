#!/usr/bin/bash

# computes a checksum of a string
# with no argument, reads the string from STDIN
checksum() {
  if [ -z "$@" ]
  then
    cat - | sha1sum | cut -c 1-40
  else
    echo -n "$@" | sha1sum | cut -c 1-40
  fi
}
export -f checksum

# simple "echo" command with colors
color_echo() {
  case "$1" in
    black   | bk) color=0; shift;;
    red     |  r) color=1; shift;;
    green   |  g) color=2; shift;;
    yellow  |  y) color=3; shift;;
    blue    |  b) color=4; shift;;
    magenta |  m) color=5; shift;;
    cyan    |  c) color=6; shift;;
    white   |  w) color=7; shift;;
    *) color=7;;
  esac
  if [ -n "$GASH_COLOR" ]
  then
    tput setaf $color 2>/dev/null
    echo $@
    tput sgr0 2>/dev/null
  else
    echo $@
  fi
}

# draws a parchment around a text file
parchment() {
  local file=$1
  [ ! -f $file ] && return 1
  if [ -x "$(command -v python3)" ]
  then
    local P=$2
    [ -z "$P" ] && P=$(( 16#$(checksum $(readlink -f $file) | cut -c 10-13) % 4 ))
    case "$P" in
      0 | 1) P="Parchment";;
      2) P="Parchment2";;
      3) P="Parchment3";;
      *) P="Parchment";;
    esac
    echo ""
    python3 $GASH_BIN/box.py -b $P < "$file"
    echo ""
  else
    echo
    cat "$file"
    echo
  fi
}


# checksum of admin password
export ADMIN_HASH="39f70a1addd8031d5e68d75c1a4432ebf115cf85"

# ask admin password: variable GASH_ADMIN is set to "OK" if password was
# correctly given, to "" otherwise
admin_mode() {
  local i mpd
  for i in $(seq 3)
  do
    read -s -p "mot de passe admin : " mdp
    echo ""
    if [ "$(checksum $mdp)" = "$ADMIN_HASH" ]
    then
      GASH_ADMIN="OK"
      return 0
    fi
  done
  GASH_ADMIN=""
  return 1
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
