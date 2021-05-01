#!/usr/bin/bash

# shellcheck disable=SC2005

source gettext.sh

# shellcheck source=./lib/utils.sh
source "$GASH_LIB/utils.sh"

trap "_gash_exit EXIT" EXIT
trap "_gash_exit TERM" SIGTERM
# trap "_gash_exit INT" SIGINT


# log an action to the missions.log file
_log_action() {
  local MISSION_NB action D S
  MISSION_NB=$1
  action=$2
  D="$(date +%s)"
  S="$(checksum "$GASH_UID#$MISSION_NB#$action#$D")"
  echo "$MISSION_NB $action $D $S" >> "$GASH_DATA/missions.log"
}


# get the last started mission
_get_current_mission() {
  local n="$(awk '/^#/ {next}   $2=="START" {m=$1}  END {print (m)}' "$GASH_DATA/missions.log")"
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
  local dir=$(awk -v n="$n" -v DIR="$GASH_MISSIONS" '/^#/{next} /^$/{next} {N++} (N == n){print DIR "/" $0; exit}' "$GASH_DATA/index.txt")
  echo "$(REALPATH "$dir")"
}

# welcome message
_gash_welcome() {
  local msg_file=$(eval_gettext '$GASH_BASE/i18n/gameshell-welcome/en.txt')
  [ -r "$msg_file" ] || return 1
  parchment "$msg_file" Braid
}

# reset the bash configuration
_gash_reset() {
  if [ "$BASHPID" != $$ ]
  then
    echo "$(gettext "The command 'gash reset' is useless when run inside a subshell!")" >&2
    return 1
  fi

  # restore SDTIN that may have been closed in case of a redirection into gash check 
  exec 0<"$GASH_STDIN"

  # on relance bash, histoire de recharcher la config
  exec bash --rcfile "$GASH_LIB/bashrc"
}


# called when gash exits
_gash_exit() {
  local MISSION_NB=$(_get_current_mission)
  local signal=$1
  _log_action "$MISSION_NB" "$signal"
  _gash_clean "$MISSION_NB"
  [ "$GASH_MODE" != "DEBUG" ] && ! [ -d "$GASH_BASE/.git" ] && _gash_unprotect
  # jobs -p | xargs kill -sSIGHUP     # ??? est-ce qu'il faut le garder ???
}


# display the goal of a mission given by its number
_gash_show() {
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
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if [ -f "$MISSION_DIR/goal.txt" ]
  then
    FILE="$MISSION_DIR/goal.txt"
    VARS=$(sed -n '/^\s*#.*variables/p;1q' "$FILE")
    if [ -z "$VARS" ]
    then
      parchment "$FILE"
    else
      sed '1d' "$FILE" | envsubst "$VARS" | parchment
    fi
  elif [ -f "$MISSION_DIR/goal.sh" ]
  then
    mission_source "$MISSION_DIR/goal.sh" | parchment
  else
    FILE="$(TEXTDOMAIN="$(basename "$MISSION_DIR")" eval_gettext '$MISSION_DIR/goal/en.txt')"
    VARS=$(sed -n '/^\s*#.*variables/p;1q' "$FILE")
    if [ -z "$VARS" ]
    then
      parchment "$FILE"
    else
      sed '1d' "$FILE" | envsubst "$VARS" | parchment
    fi
  fi
}


# display the mission index
# TODO translation support
_gash_index() {
  local CUR_MISSION="$(_get_current_mission)"
  local MISSION_NB="1"
  local MISSION COLOR STATUS LEAD

  for MISSION in $(grep -v "^#" "$GASH_DATA/index.txt" | grep "\S")
  do
    if grep -q "^$MISSION_NB CHECK_OK" "$GASH_DATA/missions.log"
    then
      COLOR="green"
      STATUS=" ($(gettext "done"))"
    elif grep -q "^$MISSION_NB CHECK_OOPS" "$GASH_DATA/missions.log"
    then
      COLOR="red"
      STATUS=" ($(gettext "failed"))"
    elif grep -q "^$MISSION_NB PASS" "$GASH_DATA/missions.log"
    then
      COLOR="yellow"
      STATUS=" ($(gettext "passed"))"
    elif grep -q "^$MISSION_NB CANCEL_DEP_PB" "$GASH_DATA/missions.log"
    then
      COLOR="magenta"
      STATUS=" ($(gettext "cancelled"))"
    else
      COLOR="white"
      STATUS=""
    fi

    LEAD="   "
    if [ "$CUR_MISSION" -eq "$MISSION_NB" ]
    then
      LEAD="-> "
    fi

    printf "%s%2d   " "$LEAD" "$MISSION_NB"
    color_echo "$COLOR" "$MISSION$STATUS"

    MISSION_NB="$((MISSION_NB + 1))"
  done
}


# start a mission given by its number
_gash_start() {
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
    if [ "$?" -eq 1 ]
    then
      _gash_welcome
      read -erp "$(gettext "Press Enter")"
    fi
  else
    MISSION_NB=$1
  fi

  [ -z "$MISSION_NB" ] && MISSION_NB=1

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"
  if [ -z "$MISSION_DIR" ]
  then
    color_echo red "$(eval_gettext "Mission \$MISSION_NB doesn't exist!
Restarting...")"
    echo
    read -erp "$(gettext "Press Enter")"
    gash reset
  fi

  ### tester le fichier deps.sh
  if [ -f "$MISSION_DIR/deps.sh" ]
  then
    mission_source "$MISSION_DIR/deps.sh"
    local exit_status=$?
    if [ "$exit_status" -ne 0 ]
    then
      echo "$(gettext "The mission is cancelled because some dependencies are not met.")" >&2
      _log_action "$MISSION_NB" "CANCEL_DEP_PB"
      _gash_start "$((MISSION_NB + 1))"
      return
    fi
  fi

  if [ -f "$MISSION_DIR/init.sh" ]
  then
    # attention, si l'initialisation a lieu dans un sous-shell et qu'elle
    # définit des variables d'environnement, elles ne seront pas définies dans
    # la session bash.
    # je sauvegarde l'environnement avant / après l'initialisation pour
    # afficher un message dans ce cas
    [ "$BASHPID" = $$ ] || compgen -v | sort > "$GASH_MISSION_DATA"/env-before
    mission_source "$MISSION_DIR/init.sh"
    [ "$BASHPID" = $$ ] || compgen -v | sort > "$GASH_MISSION_DATA"/env-after

    if [ "$BASHPID" != $$ ]
    then
      if ! cmp -s "$GASH_MISSION_DATA"/env-before "$GASH_MISSION_DATA"/env-after
      then
        echo "$(gettext "NOTE: this mission was initialized in a sub-shell.
You should run the command
    gash reset
to make sure the mission is initialized properly.")" >&2
        rm -f "$GASH_MISSION_DATA"/env-{before,after}
      fi
    fi
  fi

  _log_action "$MISSION_NB" "START"

  if [ -z "$quiet" ]
  then
    if [ "$MISSION_NB" -eq 1 ]
    then
      parchment "$(eval_gettext '$GASH_BASE/i18n/gameshell-init-msg/en.txt')" Inverted
    else
      parchment "$(eval_gettext '$GASH_BASE/i18n/gameshell-init-msg-short/en.txt')" Inverted
    fi
  fi
}

# stop a mission given by its number
_gash_pass() {
  local MISSION_NB="$(_get_current_mission)"
  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
    return 1
  fi
  if ! admin_mode
  then
    return 1
  fi
  _log_action "$MISSION_NB" "PASS"
  _gash_clean "$MISSION_NB"
  color_echo yellow "$(eval_gettext 'Mission $MISSION_NB has been cancelled.')" >&2

  _gash_start $((10#$MISSION_NB + 1))
}

# applies auto.sh script, if it exists
_gash_auto() {
  local MISSION_NB="$(_get_current_mission)"

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/auto.sh" ]
  then
    echo "$(eval_gettext "Mission \$MISSION_NB doesn't have an auto script.")" >&2
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
_gash_check() {
  local MISSION_NB="$(_get_current_mission)"

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/check.sh" ]
  then
    echo "$(eval_gettext "Error: mission \$MISSION_NB doesn't have a check script.")" >&2
    return 1
  fi

  if grep -q "^$MISSION_NB OK" "$GASH_DATA/missions.log"
  then
    echo
    color_echo yellow "$(eval_gettext "Mission \$MISSION_NB has already been succesfully checked!")"
    echo
  else
    mission_source "$MISSION_DIR/check.sh"
    local exit_status=$?

    if [ "$exit_status" -eq 0 ]
    then
      echo
      color_echo green "$(eval_gettext 'Mission $MISSION_NB has been successfully completed!')"
      echo

      _log_action "$MISSION_NB" "CHECK_OK"

      _gash_clean "$MISSION_NB"

      if [ -f "$MISSION_DIR/treasure.sh" ]
      then
        # Record the treasure to be loaded by GameShell's bashrc.
        cp "$MISSION_DIR/treasure.sh" "$GASH_CONFIG/$(basename "$MISSION_DIR" /).treasure.sh"

        # Display the text message (if it exists).
        if [ -f "$MISSION_DIR/treasure-msg.txt" ]
        then
          echo ""
          cat "$MISSION_DIR/treasure-msg.txt"
          echo ""
        elif [ -f "$MISSION_DIR/treasure-msg.sh" ]
        then
          echo ""
          mission_source "$MISSION_DIR/treasure-msg.sh"
          echo ""
        else
          local file_msg="$(TEXTDOMAIN="$(basename "$MISSION_DIR")" eval_gettext '$MISSION_DIR/treasure-msg/en.txt')"
          if [ -f "$file_msg" ]
          then
            echo ""
            cat "$file_msg"
            echo ""
          fi
        fi

        # Load the treasure in the current shell.
        mission_source "$MISSION_DIR/treasure.sh"

        #sourcing the file isn't very robust as the "gash check" may happen in a subshell!
        if [ "$BASHPID" != $$ ]
        then
          echo "$(gettext "Note: the file 'treasure.sh' was sourced from a subshell.
You are advised to use the command
    $ gash reset")"
        fi
      fi
      _gash_start $((10#$MISSION_NB + 1))
    else
      echo
      color_echo red "$(eval_gettext "Mission \$MISSION_NB hasn't been completed.")"
      echo

      _log_action "$MISSION_NB" "CHECK_OOPS"

      _gash_clean "$MISSION_NB"
      _gash_start "$MISSION_NB"
    fi
  fi
}

_gash_clean() {
  local MISSION_NB="$(_get_current_mission)"

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(_get_mission_dir "$MISSION_NB")"

  if [ -f "$MISSION_DIR/clean.sh" ]
  then
    mission_source "$MISSION_DIR/clean.sh"
  fi
}

_gash_assert_check() {
  local MISSION_NB="$(_get_current_mission)"

  local expected=$1
  if [ "$expected" != "true" ] && [ "$expected" != "false" ]
  then
    echo "$(eval_gettext "Problem: _gash_assert_check only accept 'true' and 'false' as argument")" >&2
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

  _gash_clean "$MISSION_NB"
  _gash_start -quiet "$MISSION_NB"
}
[ "$GASH_MODE" != "DEBUG" ] && unset -f _gash_assert_check

_gash_assert() {
  local condition=$1
  if [ "$condition" = "check" ]
  then
    shift
    _gash_assert_check "$@"
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
[ "$GASH_MODE" != "DEBUG" ] && unset -f _gash_assert

_gash_test() {
  local MISSION_NB="$(_get_current_mission)"
  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Problem: couldn't get mission number '\$MISSION_NB' (\$fn_name)")" >&2
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
    color_echo red "$(eval_gettext '$NB_ERRORS errors out of $NB_TESTS tests')"
    echo
  fi
  unset NB_TESTS NB_ERRORS
}
[ "$GASH_MODE" != "DEBUG" ] && unset -f _gash_test

_gash_help() {
  parchment "$(eval_gettext '$GASH_BASE/i18n/gameshell-help/en.txt')" Parchment2
}

_gash_HELP() {
  parchment "$(eval_gettext '$GASH_BASE/i18n/gameshell-HELP/en.txt')" Parchment2
}


_gash_save() {
  if jobs | grep -iq stopped
  then
    while true
    do
      read -erp "$(gettext "NOTE, there are stopped jobs in your session.
Those processes will be terminated.
You can get the list of those jobs with
    \$ jobs -s
Do you still want to save and quit? [y/N]") " r
      if [ -z "$r" ] || [ "$r" = "$(gettext "n")" ] ||  [ "$r" = "$(gettext "N")" ]
      then
        return
      elif [ "$r" = "$(gettext "y")" ] ||  [ "$r" = "$(gettext "Y")" ]
      then
        break
      fi
    done
    kill -9 $(jobs -ps)
  fi

  _log_action "$MISSION_NB" "SAVE"

  tarfile=$REAL_HOME/GameShell_$(whoami)-SAVE.tgz
  if tar -zcf "$tarfile" --exclude=".git*" -C "$GASH_BASE/.." "$(basename "$GASH_BASE")"
  then
    echo "$(eval_gettext "An archive containing your current game has been saved to

    \$tarfile

You can transfer and extract this file, and restart your game
with the start.sh script included therein.")"
  exit 0
  else
    echo
    color_echo red "$(eval_gettext "Possible failure while creating save file.")"
    echo "$(eval_gettext "Check the file

    \$tarfile

to make sure everything is OK.
")"
    return 1
  fi
}

_gash_protect() {
  chmod a-rw $GASH_BASE
  chmod a-rw $GASH_MISSIONS
  chmod a-rw $GASH_DATA
  chmod a-r $GASH_MISSION_DATA
  chmod a-rw $GASH_BIN
  chmod a-rw $GASH_LOCAL_BIN
}

_gash_unprotect() {
  chmod u+rw $GASH_BASE
  chmod u+rw $GASH_MISSIONS
  chmod u+rw $GASH_DATA
  chmod u+r $GASH_MISSION_DATA
  chmod u+rw $GASH_BIN
  chmod u+rw $GASH_LOCAL_BIN
}



gash() {
  local _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN="gash"
  local cmd=$1
  shift

  case $cmd in
    "c" | "ch" | "che" | "chec" | "check")
      _gash_check
      ;;
    "h" | "he" | "hel" | "help")
      _gash_help
      ;;
    "H" | "HE" | "HEL" | "HELP")
      _gash_HELP
      ;;
    "r" | "re" | "res" | "rese" | "reset")
      _gash_clean
      _gash_reset
      ;;
    "sa" | "sav" | "save")
      _gash_save
      ;;
    "sh" | "sho" | "show")
      _gash_show "$@"
      ;;
    "i" | "in" | "ind" | "inde" | "index")
      _gash_index
      ;;
    "w" | "we" | "wel" | "welc" | "welco" | "welcom" | "welcome")
      _gash_welcome
      ;;
    "stat")
      awk -v GASH_UID="$GASH_UID" -f "$GASH_BIN/stat.awk" < "$GASH_DATA/missions.log"
      ;;
    "exit")
      exit 0
      ;;

    # admin stuff
    # TODO: something to regenerate static world
    "pass")
        _gash_pass
      ;;
    "auto")
      _gash_auto
      ;;
    "goto")
      if [ -z "$1" ]
      then
        echo "$(gettext "The 'goto' command requires a mission number as argument.")" >&2
        return 1
      fi

      if ! admin_mode
      then
        return 1
      fi

      _gash_clean
      _gash_start "$@"
      ;;
    "test")
      if [ "$GASH_MODE" != "DEBUG" ]
      then
        echo "$(eval_gettext "Error: command '\$cmd' is only available in debug mode.")" >&2
      else
        _gash_test
      fi
      ;;
    "assert_check")
      if [ "$GASH_MODE" != "DEBUG" ]
      then
        echo "$(eval_gettext "Error: command '\$cmd' is only available in debug mode.")" >&2
      else
        _gash_assert_check "$@"
      fi
      ;;
    "assert")
      if [ "$GASH_MODE" != "DEBUG" ]
      then
        echo "$(eval_gettext "Error: command '\$cmd' is only available in debug mode.")" >&2
      else
        _gash_assert "$@"
      fi
      ;;
    "protect")
      _gash_protect
      ;;
    "unprotect")
      _gash_unprotect
      ;;
    *)
      echo "$(eval_gettext 'unkwnown gash command $cmd')" >&2
      echo "$(gettext "use one of the following commands:")  help, show, check, reset or HELP" >&2
      export TEXTDOMAIN=$_TEXTDOMAIN
      unset _TEXTDOMAIN
      return 1
      ;;
  esac
  export TEXTDOMAIN=$_TEXTDOMAIN
  unset _TEXTDOMAIN
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
