#!/usr/bin/bash

# shellcheck disable=SC2005

source gettext.sh

source "$GSH_LIB/common.sh"

trap "_gsh_exit EXIT" EXIT
trap "_gsh_exit TERM" SIGTERM
# trap "_gsh_exit INT" SIGINT


# log an action to the missions.log file
_log_action() {
  local MISSION_NB action D S
  MISSION_NB=$1
  action=$2
  D="$(date +%s)"
  S="$(checksum "$GSH_UID#$MISSION_NB#$action#$D")"
  echo "$MISSION_NB $action $D $S" >> "$GSH_CONFIG/missions.log"
}


# get the last started mission
_get_current_mission() {
  local n="$(awk '/^#/ {next}   $2=="START" {m=$1}  END {print (m)}' "$GSH_CONFIG/missions.log")"
  if [ -z "$n" ]
  then
    echo "1"
    return 1
  else
    echo "$n"
  fi
}


# get the mission directory
_get_mission_dir() {
  local n=$1
  local dir=$(awk -v n="$n" -v DIR="$GSH_MISSIONS" '/^\s*[#!]/{next} /^$/{next} {N++} (N == n){print DIR "/" $0; exit}' "$GSH_CONFIG/index.txt")
  echo "$(REALPATH "$dir")"
}

# welcome message
_gsh_welcome() {
  local msg_file=$(eval_gettext '$GSH_ROOT/i18n/gameshell-welcome/en.txt')
  [ -r "$msg_file" ] || return 1
  parchment "$msg_file" Braid
}

# reset the bash configuration
_gsh_reset() {
  if [ "$BASHPID" != $$ ]
  then
    echo "$(gettext "Error: the command 'gsh reset' is useless when run inside a subshell!")" >&2
    return 1
  fi

  # restore SDTIN that may have been closed in case of a redirection into gsh check 
  exec 0<"$GSH_STDIN"

  # on relance bash, histoire de recharcher la config
  exec bash --rcfile "$GSH_LIB/bashrc"
}


# called when gsh exits
_gsh_exit() {
  local MISSION_NB=$(_get_current_mission)
  local signal=$1

  if jobs | grep -iq stopped
  then
    while true
    do
      read -erp "$(gettext "There are stopped jobs in your session.
Those processes will be terminated.
You can get the list of those jobs with
    \$ jobs -s
Do you still want to quit? [y/n]") " r
      if [ -z "$r" ] || [ "$r" = "$(gettext "n")" ] ||  [ "$r" = "$(gettext "n")" ]
      then
        return
      elif [ "$r" = "$(gettext "y")" ] ||  [ "$r" = "$(gettext "y")" ]
      then
        break
      fi
    done
    kill -9 $(jobs -ps)
  fi

  _log_action "$MISSION_NB" "$signal"
  export GSH_LAST_ACTION='exit'
  _gsh_clean "$MISSION_NB"
  [ "$GSH_MODE" != "DEBUG" ] && ! [ -d "$GSH_ROOT/.git" ] && _gsh_unprotect
  # jobs -p | xargs kill -sSIGHUP     # ??? est-ce qu'il faut le garder ???
}


# display the goal of a mission given by its number
_gsh_goal() {
  local MISSION_NB
  if [ "$#" -eq 0 ]
  then
    MISSION_NB="$(_get_current_mission)"
  else
    MISSION_NB="$1"
    shift
  fi

  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if [ -f "$MISSION_DIR/goal.sh" ]
  then
    mission_source "$MISSION_DIR/goal.sh" | parchment | PAGER
  elif [ -f "$MISSION_DIR/goal.txt" ]
  then
    FILE="$MISSION_DIR/goal.txt"
    parchment "$FILE" | PAGER
  else
    FILE="$(TEXTDOMAIN="$(basename "$MISSION_DIR")" eval_gettext '$MISSION_DIR/goal/en.txt')"
    parchment "$FILE" | PAGER
  fi
}


# display the mission index
# TODO translation support
_gsh_index() {
  local CUR_MISSION="$(_get_current_mission)"
  local MISSION_NB="1"
  local MISSION COLOR STATUS LEAD

  local line
  while read line
  do
    if echo $line | grep -q '^\s*$'
    then
      continue
    elif echo $line | grep -q '^\s*[#!]'
    then
      continue
    fi

    if grep -q "^$MISSION_NB CHECK_OK" "$GSH_CONFIG/missions.log"
    then
      COLOR="green"
      STATUS=" ($(gettext "completed"))"
    elif grep -q "^$MISSION_NB CHECK_OOPS" "$GSH_CONFIG/missions.log"
    then
      COLOR="red"
      STATUS=" ($(gettext "failed"))"
    elif grep -q "^$MISSION_NB SKIP" "$GSH_CONFIG/missions.log"
    then
      COLOR="yellow"
      STATUS=" ($(gettext "skipped"))"
    elif grep -q "^$MISSION_NB CANCEL_DEP_PB" "$GSH_CONFIG/missions.log"
    then
      COLOR="magenta"
      STATUS=" ($(gettext "cancelled"))"
    else
      COLOR="white"
      STATUS=""
    fi

    MISSION=$(echo "$line" | sed 's/\s*[0-9][0-9]*_//')
    LEAD="   "
    if [ "$CUR_MISSION" -eq "$MISSION_NB" ]
    then
      LEAD="-> "
    fi

    printf "%s%2d   " "$LEAD" "$MISSION_NB"
    color_echo "$COLOR" "$MISSION$STATUS"

    MISSION_NB="$((MISSION_NB + 1))"
  done < "$GSH_CONFIG/index.txt"
}


# start a mission given by its number
_gsh_start() {
  local quiet=""
  if [ "$1" = "-quiet" ]
  then
    quiet="-quiet"
    shift
  fi
  local MISSION_NB D S
  if [ -z "$1" ]
  then
    MISSION_NB=$(_get_current_mission)
    if [ "$?" -eq 1 ] && [ "$GSH_MODE" != "DEBUG" ]
    then
      _gsh_welcome
      read -serp "$(gettext "Press Enter")"
      echo
    fi
  else
    MISSION_NB=$1
  fi

  [ -z "$MISSION_NB" ] && MISSION_NB=1

  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"
  if [ -z "$MISSION_DIR" ]
  then
    color_echo red "$(eval_gettext "Error: mission \$MISSION_NB doesn't exist!")" >&2
    echo

    # restore SDTIN that may have been closed in case of a redirection into gsh check 
    exec 0<"$GSH_STDIN"

    local LAST_MISSION=$(cut -d" " -f1 "$GSH_CONFIG/missions.log" | sort -n | tail -n1)
    while true
    do
      echo "$(eval_gettext "What do you want to do?
      (Enter)     restart from last mission
      (q)         quit
      (i)         display the list of missions
      (N)         restart from mission #N (N less than \$LAST_MISSION)")"
      read -erp "$(gettext "Your choice [qi] or a number:") " CHOICE

      case $CHOICE in
        "")
            unset CHOICE
            gsh reset
            ;;
        "$(gettext "q")" | "$(gettext "Q")")
          gsh exit
          ;;
        "$(gettext "i")" | "$(gettext "I")")
          gsh index
          ;;
        *[!0-9]*)
          echo "$(eval_gettext "Error: invalid choice: \$CHOICE")" >&2
          ;;
        *)
          if  [ 0 -lt "$CHOICE" ] && [ "$CHOICE" -le "$LAST_MISSION" ]
          then
            _gsh_start -quiet $CHOICE
            unset CHOICE
            gsh reset
          else
            echo "$(eval_gettext "Error: invalid mission number: \$CHOICE.
Please choose a number between 1 and \$LAST_MISSION.")" >&2
            echo >&2
            fi
            ;;
        esac
      done
  fi

  ### tester le fichier deps.sh
  if [ -f "$MISSION_DIR/deps.sh" ]
  then
    mission_source "$MISSION_DIR/deps.sh"
    local exit_status=$?
    if [ "$exit_status" -ne 0 ]
    then
      echo "$(eval_gettext "Error: mission \$MISSION_NB is cancelled because some dependencies are not met.")" >&2
      _log_action "$MISSION_NB" "CANCEL_DEP_PB"
      _gsh_start "$((MISSION_NB + 1))"
      return
    fi
  fi

  # re-source static.sh, in case some important directory was removed by accident
  [ -f "$MISSION_DIR/static.sh" ] && mission_source "$MISSION_DIR/static.sh"

  if [ -f "$MISSION_DIR/init.sh" ]
  then
    # attention, si l'initialisation a lieu dans un sous-shell et qu'elle
    # définit des variables d'environnement, elles ne seront pas définies dans
    # la session bash.
    # je sauvegarde l'environnement avant / après l'initialisation pour
    # afficher un message dans ce cas
    _PWD=$(pwd)
    [ "$BASHPID" = $$ ] || compgen -v | sort > "$GSH_VAR"/env-before
    mission_source "$MISSION_DIR/init.sh"
    [ "$BASHPID" = $$ ] || compgen -v | sort > "$GSH_VAR"/env-after

    if [ "$BASHPID" != $$ ]
    then
      if [ "$_PWD" != "$(pwd)" ] || ! cmp -s "$GSH_VAR"/env-before "$GSH_VAR"/env-after
      then
        echo "$(gettext "Error: this mission was initialized in a subshell.
You should run the command
    gsh reset
to make sure the mission is initialized properly.")" >&2
        rm -f "$GSH_VAR"/env-{before,after}
      fi
    fi
  fi

  _log_action "$MISSION_NB" "START"

  if [ -z "$GSH_QUIET_INTRO" ] && [ -z "$quiet" ]
  then
    if [ "$MISSION_NB" -eq 1 ]
    then
      parchment "$(eval_gettext '$GSH_ROOT/i18n/gameshell-init-msg/en.txt')" Inverted
    else
      parchment "$(eval_gettext '$GSH_ROOT/i18n/gameshell-init-msg-short/en.txt')" Inverted
    fi
  fi
}

# stop a mission given by its number
_gsh_skip() {
  local MISSION_NB="$(_get_current_mission)"
  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi
  if ! admin_mode
  then
    return 1
  fi
  _log_action "$MISSION_NB" "SKIP"
  export GSH_LAST_ACTION='skip'
  _gsh_clean "$MISSION_NB"
  color_echo yellow "$(eval_gettext 'Mission $MISSION_NB has been cancelled.')" >&2

  _gsh_start $((10#$MISSION_NB + 1))
}

# applies auto.sh script, if it exists
_gsh_auto() {
  local MISSION_NB="$(_get_current_mission)"

  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/auto.sh" ]
  then
    echo "$(eval_gettext "Error: mission \$MISSION_NB doesn't have an auto script.")" >&2
    return 1
  fi

  if ! admin_mode
  then
    return 1
  fi

  mission_source "$MISSION_DIR/auto.sh"
  _log_action "$MISSION_NB" "AUTO"
  return 0
}


# check completion of a mission given by its number
_gsh_check() {
  local MISSION_NB="$(_get_current_mission)"

  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/check.sh" ]
  then
    echo "$(eval_gettext "Error: mission \$MISSION_NB doesn't have a check script.")" >&2
    return 1
  fi

  mission_source "$MISSION_DIR/check.sh"
  local exit_status=$?
  # unset the _mission_check function
  unset -f _mission_check

  if [ "$exit_status" -eq 0 ]
  then
    echo
    color_echo green "$(eval_gettext 'Congratulations, mission $MISSION_NB has been successfully completed!')"
    echo

    _log_action "$MISSION_NB" "CHECK_OK"
    export GSH_LAST_ACTION='check_true'
    _gsh_clean "$MISSION_NB"

    if [ -f "$MISSION_DIR/treasure.sh" ]
    then
      # Record the treasure to be loaded by GameShell's bashrc.
      FILENAME=$GSH_BASHRC/treasure_$(printf "%04d" "$MISSION_NB")_$(basename "$MISSION_DIR"/).sh
      echo "export TEXTDOMAIN=$(textdomainname "$MISSION_DIR")" > "$FILENAME"
      cat "$MISSION_DIR/treasure.sh" >> $FILENAME
      echo "export TEXTDOMAIN=gsh" >> "$FILENAME"
      unset FILENAME

      # Display the text message (if it exists).
      if [ -f "$MISSION_DIR/treasure-msg.sh" ]
      then
        echo
        mission_source "$MISSION_DIR/treasure-msg.sh"
        echo
      elif [ -f "$MISSION_DIR/treasure-msg.txt" ]
      then
        echo
        cat "$MISSION_DIR/treasure-msg.txt"
        echo
      else
        local file_msg="$(TEXTDOMAIN="$(basename "$MISSION_DIR")" eval_gettext '$MISSION_DIR/treasure-msg/en.txt')"
        if [ -f "$file_msg" ]
        then
          echo
          cat "$file_msg"
          echo
        fi
      fi

      # Load the treasure in the current shell.
      mission_source "$MISSION_DIR/treasure.sh"

      #sourcing the file isn't very robust as the "gsh check" may happen in a subshell!
      if [ "$BASHPID" != $$ ]
      then
        echo "$(gettext "Error: the file 'treasure.sh' was sourced from a subshell.
You should use the command
  $ gsh reset")" >&2
      fi
    fi
    _gsh_start $((10#$MISSION_NB + 1))
  else
    echo
    color_echo red "$(eval_gettext "Sorry, mission \$MISSION_NB hasn't been completed.")"
    echo

    _log_action "$MISSION_NB" "CHECK_OOPS"
    export GSH_LAST_ACTION='check_false'
    _gsh_clean "$MISSION_NB"
    _gsh_start "$MISSION_NB"
  fi
}

_gsh_clean() {
  local MISSION_NB="$(_get_current_mission)"

  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if [ -f "$MISSION_DIR/clean.sh" ]
  then
    mission_source "$MISSION_DIR/clean.sh"
  fi
  unset GSH_LAST_ACTION
}

_gsh_assert_check() {
  local MISSION_NB="$(_get_current_mission)"

  local expected=$1
  if [ "$expected" != "true" ] && [ "$expected" != "false" ]
  then
    echo "$(eval_gettext "Error: _gsh_assert_check only accept 'true' and 'false' as argument.")" >&2
    return 1
  fi
  local msg=$3

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  mission_source "$MISSION_DIR/check.sh"
  local exit_status=$?

  NB_TESTS=$((NB_TESTS + 1))
  if [ "$expected" = "true" ] && [ "$exit_status" -ne 0 ]
  then
    NB_ERRORS=$((NB_ERRORS + 1))
    color_echo red "$(eval_gettext 'test $NB_TESTS failed') (expected check 'true')"
    [ -n "$msg" ] && echo "$msg"
  elif [ "$expected" = "false" ] && [ "$exit_status" -eq 0 ]
  then
    NB_ERRORS=$((NB_ERRORS + 1))
    color_echo red "$(eval_gettext 'test $NB_TESTS failed') (expected check 'false')"
    [ -n "$msg" ] && echo "$msg"
  fi

  export GSH_LAST_ACTION="assert_check"
  _gsh_clean "$MISSION_NB"
  _gsh_start -quiet "$MISSION_NB"
}
[ "$GSH_MODE" != "DEBUG" ] && unset -f _gsh_assert_check

_gsh_assert() {
  local condition=$1
  if [ "$condition" = "check" ]
  then
    shift
    _gsh_assert_check "$@"
    return
  fi
  local msg=$2

  NB_TESTS=$((NB_TESTS + 1))
  if ! eval "$condition"
  then
    NB_ERRORS=$((NB_ERRORS + 1))
    color_echo red "$(eval_gettext 'test $NB_TESTS failed') (expected condition 'true')"
    [ -n "$msg" ] && echo "$msg"
  fi
}
[ "$GSH_MODE" != "DEBUG" ] && unset -f _gsh_assert

_gsh_test() {
  local MISSION_NB="$(_get_current_mission)"
  if [ -z "$MISSION_NB" ]
  then
    local FUNCTION_NAME="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$FUNCTION_NAME)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/test.sh" ]
  then
    echo "$(eval_gettext "Error: mission \$MISSION_NB doesn't have a test script.")" >&2
    return 1
  fi

  export NB_TESTS=0
  export NB_ERRORS=0
  mission_source "$MISSION_DIR/test.sh"
  if [ "$NB_ERRORS" = 0 ]
  then
    echo
    color_echo green "$(eval_gettext '$NB_TESTS successful tests')"
    echo
  else
    echo
    color_echo red "$(eval_gettext '$NB_ERRORS failures out of $NB_TESTS tests')"
    echo
  fi
  unset NB_TESTS NB_ERRORS
}
[ "$GSH_MODE" != "DEBUG" ] && unset -f _gsh_test

_gsh_help() {
  parchment "$(eval_gettext '$GSH_ROOT/i18n/gameshell-help/en.txt')" Parchment2
}

_gsh_HELP() {
  parchment "$(eval_gettext '$GSH_ROOT/i18n/gameshell-HELP/en.txt')" Parchment2
}

_gsh_protect() {
  chmod a-rw $GSH_ROOT
  chmod a-rw $GSH_MISSIONS
  chmod a-rw $GSH_CONFIG
  chmod a-r $GSH_VAR
  chmod a-rw $GSH_BIN
  chmod a-rw $GSH_MISSIONS_BIN
}

_gsh_unprotect() {
  chmod u+rw $GSH_ROOT
  chmod u+rw $GSH_MISSIONS
  chmod u+rw $GSH_CONFIG
  chmod u+r $GSH_VAR
  chmod u+rw $GSH_BIN
  chmod u+rw $GSH_MISSIONS_BIN
}



gsh() {
  local _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN="gsh"
  local CMD=$1
  shift

  case $CMD in
    "c" | "ch" | "che" | "chec" | "check")
      _gsh_check
      ;;
    "h" | "he" | "hel" | "help")
      _gsh_help
      ;;
    "H" | "HE" | "HEL" | "HELP")
      _gsh_HELP
      ;;
    "r" | "re" | "res" | "rese" | "reset")
      export GSH_LAST_ACTION='check_reset'
      _gsh_clean
      _gsh_reset
      ;;
    "g" | "go" | "goa" | "goal")
      _gsh_goal "$@"
      ;;
    "i" | "in" | "ind" | "inde" | "index")
      _gsh_index | PAGER
      ;;
    "w" | "we" | "wel" | "welc" | "welco" | "welcom" | "welcome")
      _gsh_welcome
      ;;
    "stat")
      awk -v GSH_UID="$GSH_UID" -f "$GSH_BIN/stat.awk" < "$GSH_CONFIG/missions.log"
      ;;
    "exit")
      exit 0
      ;;

    # admin stuff
    # TODO: something to regenerate static world
    "skip")
        _gsh_skip
      ;;
    "auto")
      _gsh_auto
      ;;
    "goto")
      if [ -z "$1" ]
      then
        echo "$(gettext "Error: the 'goto' command requires a mission number as argument.")" >&2
        return 1
      fi

      if ! admin_mode
      then
        return 1
      fi

      export GSH_LAST_ACTION='check_goto'
      _gsh_clean
      _gsh_start "$@"
      ;;
    "test")
      if [ "$GSH_MODE" != "DEBUG" ]
      then
        echo "$(eval_gettext "Error: command '\$CMD' is only available in debug mode.")" >&2
      else
        _gsh_test
      fi
      ;;
    "assert_check")
      if [ "$GSH_MODE" != "DEBUG" ]
      then
        echo "$(eval_gettext "Error: command '\$CMD' is only available in debug mode.")" >&2
      else
        _gsh_assert_check "$@"
      fi
      ;;
    "assert")
      if [ "$GSH_MODE" != "DEBUG" ]
      then
        echo "$(eval_gettext "Error: command '\$CMD' is only available in debug mode.")" >&2
      else
        _gsh_assert "$@"
      fi
      ;;
    "protect")
      _gsh_protect
      ;;
    "unprotect")
      _gsh_unprotect
      ;;
    *)
      echo "$(eval_gettext "Error: unknown gsh command '\$CMD'.
Use one of the following commands:")  check, goal, help, HELP or reset" >&2
      export TEXTDOMAIN=$_TEXTDOMAIN
      unset _TEXTDOMAIN
      return 1
      ;;
  esac
  export TEXTDOMAIN=$_TEXTDOMAIN
  unset _TEXTDOMAIN
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
