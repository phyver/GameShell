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

TEXTDOMAINDIR="$GSH_ROOT/locale"
TEXTDOMAIN="gsh"

# PATH=$PATH:"$GSH_ROOT/bin"
PATH="$GSH_ROOT/bin":$PATH

### generate GameShell translation files for gettext
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


if ! bash "$GSH_ROOT/lib/bin_test.sh"
then
  echo "$(gettext "Error: a least one base function is not working properly.
Aborting!")"
  exit 1
fi

textdomainname() {
  local MISSION_DIR=$(realpath "$1")  # follow symbolic links to make sure translation is found
  echo "${MISSION_DIR#$GSH_MISSIONS/}" | tr "/" ","
}
export -f textdomainname

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
  echo
  if command -v python3 &> /dev/null
  # if available, use the python box8.py script
  then
    if [ -z "$file" ]
    then
      python3 "$GSH_UTILS/box8.py" --center --box="$P"
    else
      python3 "$GSH_UTILS/box8.py" --center --box="$P" < "$file"
    fi
  else
  # if not, use the awk version
    if [ -z "$file" ]
    then
      bash "$GSH_UTILS/box.sh" "$P"
      rm -f "$tempfile"
    else
      bash "$GSH_UTILS/box.sh" "$P" "$file"
    fi
  fi
  echo
}

# display a treasure message
treasure_message() {
  local WIDTH=31  # width of treasure-chest.txt file (wc -L)
  paste "$GSH_LIB/ascii-art/treasure-chest.txt" "$1" | awk -v width=$WIDTH -v seed=$RANDOM '
BEGIN{
    srand(seed) ;
    chars = ".\",-_ ";
}
/^\t/ {
    s = "";
    for (i=0; i<width; i++) {
        if (rand() < 0.05) {
            s = s "" substr(chars, int(rand()*length(chars)), 1);
        } else {
            s = s " ";
        }
    }
    print s "" $0;
}
/^[^\t]/ { print $0; }
' | column -t -s$'\t'
}

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
