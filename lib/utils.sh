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
  if [ -n "$GSH_COLOR" ]
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
    [ -z "$P" ] && P=$(( 16#$(checksum "$GSH_UID:$MISSION_DIR" | cut -c 10-17) % 7 ))
    case "$P" in
      0) P="Parchment1";;
      1) P="Parchment2";;
      2) P="Parchment3";;
      3) P="Parchment4";;
      4) P="Parchment5";;
      5) P="Parchment6";;
      6) P="Parchment7";;
      7) P="Parchment8";;
      8) P="Parchment9";;
    esac
    echo ""
    if [ -z "$file" ]
    then
      python3 "$GSH_BIN/box8.py" --center --box="$P"
    else
      python3 "$GSH_BIN/box8.py" --center --box="$P" < "$file"
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


# ask admin password, except in DEBUG mode
admin_mode() {
  if [ "$GSH_MODE" = "DEBUG" ]
  then
    return 0
  fi

  if ! [ -f "$GSH_DATA/admin_hash" ]
  then
    echo "$(gettext "Error: you are not allowed to run this command.")" >&2
    return 1
  fi

  local HASH=$(cat "$GSH_DATA/admin_hash")
  for _ in $(seq 3)
  do
    read -serp "$(gettext "password:" )" mdp
    echo ""
    if [ "$(checksum "$mdp")" = "$HASH" ]
    then
      return 0
    fi
  done
  echo "$(gettext "Error: wrong password")" >&2
  return 1
}


# this function is used to source a mission file with the corresponding
# TEXTDOMAIN value. The value of TEXTDOMAIN is saved and restored after.
# Also, in DEBUG mode, is compares the environment before / after to
# make it easier to detect variables that haven't been unset.
mission_source() {
  local FILENAME=$1
  # if we are not running in DEBUG mode, just source the file
  if [ "$GSH_MODE" != "DEBUG" ] || [ -z "$GSH_VERBOSE_SOURCE" ]
  then
    local _TEXTDOMAIN=$TEXTDOMAIN
    export TEXTDOMAIN="$(basename "$MISSION_DIR")"
    local _MISSION_NAME=$MISSION_NAME
    export MISSION_NAME="$(basename "$MISSION_DIR")"
    source "$FILENAME"
    local exit_status=$?
    export TEXTDOMAIN=$_TEXTDOMAIN
    export MISSION_NAME=$_MISSION_NAME
    return $exit_status
  fi

  local TEMP=$(mktemp -d "$GSH_MISSION_DATA/env-XXXXXX")
  local source_ret_value=""  # otherwise, it appears in the environment!
  local _TEXTDOMAIN=""
  local _MISSION_NAME=""
  local MISSION_NAME=""
  local exit_status=""
  # otherwise, record the environment (variables, functions and aliases)
  # before and after to echo a message when there are differences
  compgen -v | sort > "$TEMP"/before-V
  compgen -A function | sort > "$TEMP"/before-F
  compgen -a | sort > "$TEMP"/before-A
  ls "$GSH_MISSION_DATA" > "$TEMP"/before-D
  _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN="$(basename "$MISSION_DIR")"
  _MISSION_NAME=$MISSION_NAME
  export MISSION_NAME="$(basename "$MISSION_DIR")"
  source "$FILENAME"
  exit_status=$?
  export TEXTDOMAIN=$_TEXTDOMAIN
  export MISSION_NAME=$_MISSION_NAME
  compgen -v | sort > "$TEMP"/after-V
  # FIXME: not a very nice way to ignore _mission_check function (should only
  # be used when sourcing check.sh)
  compgen -A function | grep -v "_mission_check" | sort > "$TEMP"/after-F
  compgen -a | sort > "$TEMP"/after-A
  ls "$GSH_MISSION_DATA" > "$TEMP"/after-D

  local msg="DEBUG: environment modifications while sourcing .../${FILENAME#$GSH_BASE/}"
  if ! cmp -s "$TEMP"/{before,after}-V
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "variables before / after"
    comm -3 "$TEMP"/{before,after}-V
  fi

  if ! cmp -s "$TEMP"/{before,after}-F
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "functions before / after"
    comm -3 "$TEMP"/{before,after}-F
  fi

  if ! cmp -s "$TEMP"/{before,after}-A
  then
    [ -n "$msg" ] && echo "$msg"
    msg=""
    echo "Alias before / after"
    comm -3 "$TEMP"/{before,after}-A
  fi

  if ! cmp -s "$TEMP"/{before,after}-D
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
