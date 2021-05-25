#!/bin/bash

[ -z "$GSH_ROOT" ] && echo "Error: GSH_ROOT undefined" && exit 1

### defining GSH directories

# first, resolve symbolic links in GSH_ROOT
GSH_ROOT=$(cd "$GSH_ROOT" && pwd -P)

# these directories should not be modified during a game
export GSH_LIB="$GSH_ROOT/lib"
export GSH_MISSIONS="$GSH_ROOT/missions"
export GSH_UTILS="$GSH_ROOT/utils"

# these directories should be erased when a new game is started, they only contain
# dynamic data
export GSH_HOME="$GSH_ROOT/World"
export GSH_CONFIG="$GSH_ROOT/.config"
export GSH_VAR="$GSH_ROOT/.var"
export GSH_BASHRC="$GSH_ROOT/.bashrc"
export GSH_BIN="$GSH_ROOT/.bin"
export GSH_SBIN="$GSH_ROOT/.sbin"

export TEXTDOMAINDIR="$GSH_ROOT/locale"
export TEXTDOMAIN="gsh"

# PATH=$PATH:"$GSH_ROOT/bin"
PATH="$GSH_ROOT/bin":$PATH

### generate GameShell translation files
shopt -s nullglob
for PO_FILE in "$GSH_ROOT"/i18n/*.po; do
  PO_LANG=$(basename "$PO_FILE" .po)
  MO_FILE="$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo"
  if ! [ -f "$MO_FILE" ] || [ "$PO_FILE" -nt "$MO_FILE" ]
  then
    mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
    msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
  fi
done
shopt -u nullglob


### test some of the scripts
if ! bash "$GSH_ROOT/lib/bin_test.sh"
then
  echo "$(gettext "Error: a least one base function is not working properly.
Aborting!")"
  exit 1
fi

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
    auto.sh | check.sh | clean.sh | deps.sh | init.sh | static.sh | test.sh)
      MISSION_FN=_mission_${MISSION_FN%.*}
      ;;
    *)
      MISSION_FN='^\s*$'
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
    source "$FILENAME"
    local exit_status=$?
    export TEXTDOMAIN=$_TEXTDOMAIN
    export MISSION_NAME=$_MISSION_NAME
    export MISSION_DIR=$_MISSION_DIR
    export PATH=$_PATH
    unset -f "$MISSION_FN"
    return $exit_status
  fi

  echo "DEBUG: sourcing ${FILENAME#GSH_ROOT/}"
  local TEMP=$(mktemp -d "$GSH_VAR/env-XXXXXX")
  local source_ret_value=""  # otherwise, it appears in the environment!
  local _MISSION_DIR=""
  local _TEXTDOMAIN=""
  local _MISSION_NAME=""
  local MISSION_NAME=""
  local _PATH=""
  local exit_status=""

  # otherwise, record the environment (variables, functions and aliases)
  # before and after to echo a message when there are differences
  compgen -v | sort > "$TEMP"/before-V
  compgen -A function | sort > "$TEMP"/before-F
  compgen -a | sort > "$TEMP"/before-A
  local _MISSION_DIR=$MISSION_DIR
  export MISSION_DIR=$(dirname "$(realpath "$FILENAME")")
  _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN=$(textdomainname "$MISSION_DIR")
  _MISSION_NAME=$MISSION_NAME
  export MISSION_NAME=${FILENAME#$GSH_MISSIONS/}
  local _PATH=$PATH
  export PATH=$PATH:$GSH_SBIN
  source "$FILENAME"
  exit_status=$?
  export TEXTDOMAIN=$_TEXTDOMAIN
  export MISSION_NAME=$_MISSION_NAME
  export MISSION_DIR=$_MISSION_DIR
  export PATH=$_PATH
  compgen -v | sort > "$TEMP"/after-V
  compgen -A function | sed "/$MISSION_FN/d" | sort > "$TEMP"/after-F
  compgen -a | sort > "$TEMP"/after-A

  local msg="DEBUG: environment modifications while sourcing .../${FILENAME#$GSH_ROOT/}"
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

  rm -rf "$TEMP"
  unset -f "$MISSION_FN"
  return $exit_status
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
