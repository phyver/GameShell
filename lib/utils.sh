#!/usr/bin/bash

# computes a checksum of a string
# with no argument, reads the string from STDIN
checksum() {
  if [ "$#" -eq 0 ]
  then
    sha1sum | cut -c 1-40
  else
    echo -n "$@" | sha1sum | cut -c 1-40
  fi
}
export -f checksum

# simple "echo" command with colors
color_echo() {
  local color
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
    echo "$@"
    tput sgr0 2>/dev/null
  else
    echo "$@"
  fi
}

# draws a parchment around a text file
parchment() {
  local file=$1
  [ -n "$file" ] && [ ! -e "$file" ] && return 1
  if [ -x "$(command -v python3)" ]
  then
    local P=$2
    [ -z "$P" ] && P=$(( 16#$(checksum "$GASH_UID:$MISSION_DIR" | cut -c 10-17) % 7 ))
    case "$P" in
      0 | 1) P="Parchment";;
      2) P="Parchment2";;
      3) P="Parchment3";;
      4) P="Parchment4";;
      5) P="Scroll";;
      6) P="Scroll2";;
    esac
    echo ""
    if [ -z "$file" ]
    then
      python3 "$GASH_BIN/box8.py" -b $P
    else
      python3 "$GASH_BIN/box8.py" -b $P < "$file"
    fi
    echo ""
  else
    echo ""
    if [ -z "$file" ]
    then
      cat
    else
      cat "$file"
    fi
    echo ""
  fi
}


# checksum of admin password
export ADMIN_HASH='85ba6c834086d5f322acdea13f710c482b1a4f2a'


# ask admin password, except in DEBUG mode
admin_mode() {
  if [ "$GASH_MODE" = "DEBUG" ]
  then
    return 0
  fi

  for _ in $(seq 3)
  do
    read -serp "mot de passe admin : " mdp
    echo ""
    if [ "$(checksum "$mdp")" = "$ADMIN_HASH" ]
    then
      return 0
    fi
  done
  return 1
}


# this function is used to source a mission file with the corresponding
# TEXTDOMAIN value. The value of TEXTDOMAIN is saved and restored after.
# Also, in DEBUG mode, is compares the environment before / after to
# make it easier to detect variables that haven't been unset.
mission_source() {
  local FILENAME=$1
  # if we are not running in DEBUG mode, just source the file
  if [ "$GASH_MODE" != "DEBUG" ]
  then
    local _TEXTDOMAIN=$TEXTDOMAIN
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    source "$FILENAME"
    local exit_status=$?
    export TEXTDOMAIN=$_TEXTDOMAIN
    return $exit_status
  fi

  local TEMP=$(mktemp -d "$GASH_MISSION_DATA/env-XXXXXX")
  local source_ret_value=""  # otherwise, it appears in the environment!
  local _TEXTDOMAIN=""
  local exit_status=""
  # otherwise, record the environment (variables, functions and aliases)
  # before and after to echo a message when there are differences
  compgen -v | sort > "$TEMP"/before-V
  compgen -A function | sort > "$TEMP"/before-F
  compgen -a | sort > "$TEMP"/before-A
  ls "$GASH_MISSION_DATA" > "$TEMP"/before-D
  _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN="$(basename "$MISSION_DIR")"
  source "$FILENAME"
  exit_status=$?
  export TEXTDOMAIN=$_TEXTDOMAIN
  compgen -v | sort > "$TEMP"/after-V
  compgen -A function | sort > "$TEMP"/after-F
  compgen -a | sort > "$TEMP"/after-A
  ls "$GASH_MISSION_DATA" > "$TEMP"/after-D

  local msg="DEBUG: environment modifications while sourcing .../${FILENAME#$GASH_BASE/}"
  if ! cmp --quiet "$TEMP"/{before,after}-V
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "variables before / after"
    comm -3 "$TEMP"/{before,after}-V
  fi

  if ! cmp --quiet "$TEMP"/{before,after}-F
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "functions before / after"
    comm -3 "$TEMP"/{before,after}-F
  fi

  if ! cmp --quiet "$TEMP"/{before,after}-A
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "Alias before / after"
    comm -3 "$TEMP"/{before,after}-A
  fi

  if ! cmp --quiet "$TEMP"/{before,after}-D
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "mission data, before / after"
    comm -3 "$TEMP"/{before,after}-D
  fi

  rm -rf "$TEMP"
  return $exit_status
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
