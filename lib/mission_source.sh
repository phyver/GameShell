#!/bin/bash

###
# THIS FILE SHOULD BE SOURCED TO DEFINE THE mission_source FUNCTION.
###

# this function is used to source a mission file with the corresponding
# MISSION_DIR and TEXTDOMAIN values. Since those values are derived from the
# directory containing the file, **the file MUST be in the root directory of
# the mission**.
# The current values of MISSION_DIR and TEXTDOMAIN are saved and restored
# after.
# Also, in DEBUG mode, is compares the environment before / after to make it
# easier to detect variables that haven't been unset.
# NOTE: MISSION_DIR and TEXTDOMAIN refer to the physical location (symbolic
# links are resolved), while MISSION_NAME refers to the logical location of the
# file.
mission_source() {
  local FILENAME=$1
  # the function corresponding to the file name:
  #   static.sh => _mission_static
  #   check.sh => _mission_check
  #   etc.
  local MISSION_FN=$(basename "$FILENAME")
  case "$MISSION_FN" in
    auto.sh | check.sh | clean.sh | init.sh | static.sh | test.sh)
      MISSION_FN=_mission_${MISSION_FN%.*}
      ;;
    *)
      MISSION_FN='^[[:blank:]]*$'
      ;;
  esac
  # if we are not running in DEBUG mode, just source the file
  if [ "$GSH_MODE" != "DEBUG" ] || [ -z "$GSH_VERBOSE_DEBUG" ]
  then
    local _MISSION_DIR=$MISSION_DIR
    export MISSION_DIR=$(dirname "$(realpath "$FILENAME")")
    local _TEXTDOMAIN=$TEXTDOMAIN
    export TEXTDOMAIN=$(textdomainname "$MISSION_DIR")
    local _MISSION_NAME=$MISSION_NAME
    export MISSION_NAME=${FILENAME#$GSH_MISSIONS/}
    local _PATH=$PATH
    export PATH=$PATH:$GSH_SBIN
    . "$FILENAME"
    local exit_status=$?
    export TEXTDOMAIN=$_TEXTDOMAIN
    export MISSION_NAME=$_MISSION_NAME
    export MISSION_DIR=$_MISSION_DIR
    export PATH=$_PATH
    unset -f "$MISSION_FN"
    return $exit_status
  fi

  echo "    GSH: sourcing \$GSH_ROOT/${FILENAME#$GSH_ROOT/}" >&2
  local _MISSION_DIR=""  # otherwise, it appears in the environment!
  local _TEXTDOMAIN=""
  local _MISSION_NAME=""
  local MISSION_NAME=""
  local _PATH=""
  local exit_status=""
  local env_before=$(mktemp)
  local env_after=$(mktemp)

  # otherwise, record the environment (variables, functions and aliases)
  # before and after to echo a message when there are differences
  . save_environment.sh >"$env_before"
  local _MISSION_DIR=$MISSION_DIR
  export MISSION_DIR=$(dirname "$(realpath "$FILENAME")")
  _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN=$(textdomainname "$MISSION_DIR")
  _MISSION_NAME=$MISSION_NAME
  export MISSION_NAME=${FILENAME#$GSH_MISSIONS/}
  local _PATH=$PATH
  export PATH=$PATH:$GSH_SBIN
  . "$FILENAME"
  exit_status=$?
  export TEXTDOMAIN=$_TEXTDOMAIN
  export MISSION_NAME=$_MISSION_NAME
  export MISSION_DIR=$_MISSION_DIR
  export PATH=$_PATH
  . save_environment.sh | grep -v "$MISSION_FN" > "$env_after"

  if ! cmp -s "$env_before" "$env_after"
  then
    echo "GSH: environment modifications while sourcing \$GSH_ROOT/${FILENAME#$GSH_ROOT/}" >&2
    comm -23 "$env_before" "$env_after" | sed "s/^/-/"
    comm -13 "$env_before" "$env_after" | sed "s/^/+/"
  fi

  rm -f "$env_before" "$env_after"
  unset -f "$MISSION_FN"
  return $exit_status
}

