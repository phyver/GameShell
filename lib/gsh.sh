#!/usr/bin/env sh

# warning about "echo $(cmd)", used many times with echo "$(gettext ...)"
# shellcheck disable=SC2005
#
# warning about eval_gettext '$GSH_ROOT/...' about variable not expanding in single quotes
# shellcheck disable=SC2016
#
# warning about using printf "$(gettext ...)" because the string may contain
# escape characters (they don't)
# shellcheck disable=SC2059
#
# warning about declaring and initializing at the same time: local x=...
# shellcheck disable=SC2155

# shellcheck source=/dev/null
. gsh_gettext.sh

# shellcheck source=lib/mission_source.sh
. "$GSH_LIB/mission_source.sh"

trap '_gsh_exit EXIT $?' EXIT
trap '_gsh_exit TERM 15' TERM
trap '_gsh_exit HUP --force 2' HUP
# trap '_gsh_exit INT' INT  # causes termination on ^C


# log an action to the missions.log file
__log_action() {
  local MISSION_NB action D S prev_cksum
  MISSION_NB=$1
  action=$2
  D="$(date +%s)"
  if [ -e "$GSH_CONFIG/prev_cksum" ]
  then
    prev_cksum=$(cat "$GSH_CONFIG/prev_cksum")
  else
    prev_cksum=$(cat "$GSH_CONFIG/uid")
  fi
  S="$(checksum "$prev_cksum#$MISSION_NB#$action#$D")"
  printf '%s %s %s %s\n' "$MISSION_NB" "$action" "$D" "$S" >> "$GSH_CONFIG/missions.log"
  echo "$S" >"$GSH_CONFIG/prev_cksum"
}


_gsh_reset() {
  local MISSION_NB="$(_gsh_pcm)"
  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi
  if ! . mainshell.sh
  then
    echo "$(gettext "Error: the command 'gsh reset' shouldn't be run inside a subshell!")" >&2
    return 1
  fi

  __gsh_start "$MISSION_NB"
}

# reload the shell
_gsh_hard_reset() {
  local MISSION_NB="$(_gsh_pcm)"
  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi
  if ! . mainshell.sh
  then
    echo "$(gettext "Error: the command 'gsh hardreset' shouldn't be run inside a subshell!")" >&2
    return 1
  fi
  __log_action "$MISSION_NB" "HARD_RESET"
  # reload the shell, making sure it reads its config file by making it interactive (-i)
  generate_rcfile
  exec "$GSH_SHELL" -i
}

# regenerate the world by sourcing all the static.sh mission files
_gsh_resetstatic() {
  if ! . mainshell.sh
  then
    echo "$(gettext "Error: the command 'gsh reset' shouldn't be run inside a subshell!")" >&2
    return 1
  fi

  # looping through all missions.
  while read -r MISSION_DIR
  do
    case $MISSION_DIR in
      "" | "#"* )
        continue
        ;;
      "!"*)
        MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
        ;;
    esac

    export MISSION_DIR
    MISSION_DIR=$GSH_MISSIONS/$MISSION_DIR

    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(textdomainname "$MISSION_DIR")

    # source the static part of the mission
    if [ -f "$MISSION_DIR/static.sh" ]
    then
      mission_source "$MISSION_DIR/static.sh"
    fi

    if [ "$GSH_MODE" = "DEBUG" ] && [ "$GSH_VERBOSE_DEBUG" = true ]
    then
      printf '    GSH: mission %3d -> %s\n' "$MISSION_NB" "\$GSH_MISSIONS/${MISSION_DIR#$GSH_MISSIONS/}" >&2
    else
      printf "." >&2
    fi

  done < "$GSH_CONFIG/index.txt"
  echo "" >&2

  unset MISSION_DIR DOMAIN
}

# called when gsh exits
_gsh_exit() {
  local MISSION_NB=$(_gsh_pcm)
  local signal=$1
  shift

  if [ "$1" = "--force" ]
  then
    local FORCE=1
    shift
  fi

  local exit_value=$1

  #TODO HERE
  if [ -z "$FORCE" ] && LC_ALL=C jobs | grep -iqE "stopped|suspended"  # bash uses "stopped", zsh uses "suspended"
  then
    while true
    do
      printf "$(gettext "There are stopped jobs in your session.
Those processes will be terminated.
You can get the list of those jobs with
    \$ jobs
Do you still want to quit? [y/n]") "
      local resp
      read -r resp
      if [ -z "$resp" ] || [ "$resp" = "$(gettext "n")" ] ||  [ "$resp" = "$(gettext "n")" ]
      then
        return
      elif [ "$resp" = "$(gettext "y")" ] ||  [ "$resp" = "$(gettext "y")" ]
      then
        break
      fi
    done
    ## NOTE: jobs -p doesn't give pids in zsh
    ## stopped jobs are terminated anyway (at least in bash and zsh)
    # kill $(jobs -pl)
    ## running jobs are kept in bash, but terminated in zsh (except if option
    ## NO_HUP has been set)
  fi

  __log_action "$MISSION_NB" "$signal"
  export GSH_LAST_ACTION='exit'
  __gsh_clean "$MISSION_NB"
  [ "$GSH_MODE" != "DEBUG" ] && ! [ -d "$GSH_ROOT/.git" ] && gsh unprotect
  [ -e "$GSH_ROOT/.save" ] && __save
  # remove the ".save" file to make sure we don't always save from now on!
  rm -f "$GSH_ROOT/.save"

  ## NOTE: without that, calling exit in zsh doesn't work if there are running
  ## jobs (independantly of the option NO_HUP)
  [ -n "$ZSH_VERSION" ] && setopt +o MONITOR
  trap - EXIT   # do not call this function another time!
  exit "$exit_value"
}


# start a mission given by its number
__gsh_start() {
  local quiet=""
  if [ "$1" = "--quiet" ]
  then
    quiet="--quiet"
    shift
  fi
  local MISSION_NB D S
  if [ -z "$1" ]
  then
    MISSION_NB=$(_gsh_pcm)
    local new_game=$?
    if [ -z "$GSH_QUIET_INTRO" ] && [ "$new_game" -eq 1 ] && [ "$GSH_MODE" != "DEBUG" ]
    then
      gsh welcome
      echo
      printf "$(gettext "Press Enter to continue.")"
      stty -echo 2>/dev/null    # ignore errors, in case input comes from a redirection
      read
      stty echo 2>/dev/null    # ignore errors, in case input comes from a redirection
      clear
    fi
  else
    MISSION_NB=$1
  fi

  [ -z "$MISSION_NB" ] && MISSION_NB=1

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(missiondir "$MISSION_NB")"
  if [ -z "$MISSION_DIR" ]
  then
    echo
    color_echo red "$(eval_gettext "Error: mission \$MISSION_NB doesn't exist!")" >&2
    echo
    __log_action "$MISSION_NB" "UNKNOWN_MISSION"
    gsh reset
    return 1
  fi


  # re-source static.sh, in case some important directory was removed by accident
  [ -f "$MISSION_DIR/static.sh" ] && mission_source "$MISSION_DIR/static.sh"

  if [ -f "$MISSION_DIR/init.sh" ]
  then
    # If init.sh is sourced in a subshell, variable definitions, changes of
    # PWD, functions or aliases defined in init.sh will disappear.
    # I save the environment before / after and display a warning when that's the case.
    if ! . mainshell.sh
    then
      local env_before=$(mktemp)
      local env_after=$(mktemp)
      . print_current_environment.sh > "$env_before"
    fi


    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(textdomainname "$MISSION_DIR")
    mission_source "$MISSION_DIR/init.sh"
    local exit_status=$?
    unset DOMAIN

    if [ "$exit_status" -ne 0 ]
    then
      # the GSH_CANCELLED variable keeps track of consecutive cancelled missions
      # to prevent looping if all the missions are cancelled.
      # It is unset on the first non-cancelled mission.
      if echo "$GSH_CANCELLED" | grep -Eq ":$MISSION_NB(:|$)"
      then
        echo "$(gettext "Error: no mission was found!
Aborting.")" >&2
        exit 1
      fi
      color_echo yellow "$(eval_gettext "Error: mission \$MISSION_NB is cancelled because some dependencies are not met.")" >&2
      GSH_CANCELLED=$GSH_CANCELLED:$MISSION_NB
      __log_action "$MISSION_NB" "CANCEL_DEP_PB"
      __gsh_start "$((MISSION_NB + 1))"
      return
    fi
    unset GSH_CANCELLED

    if ! . mainshell.sh
    then
      . print_current_environment.sh > "$env_after"

      if ! cmp -s "$env_before" "$env_after"
      then
        color_echo yellow "$(gettext "Warning: this mission was initialized in a subshell.
Run the command
    \$ gsh reset
to make sure the mission is initialized properly.")" >&2
        rm -f "$env_before" "$env_after"
      fi
    fi
  fi

  __log_action "$MISSION_NB" "START"

  if [ -z "$GSH_QUIET_INTRO" ] && [ -z "$quiet" ]
  then
    if [ "$MISSION_NB" -eq 1 ]
    then
      parchment -B Inverted "$(eval_gettext '$GSH_ROOT/i18n/gameshell-init-msg/en.txt')"
    else
      parchment -B Inverted "$(eval_gettext '$GSH_ROOT/i18n/gameshell-init-msg-short/en.txt')"
    fi
  fi
}

# stop a mission given by its number
_gsh_skip() {
  local MISSION_NB="$(_gsh_pcm)"
  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi
  local MISSION_DIR="$(missiondir "$MISSION_NB")"

  # allow skipping completed missions
  if ! grep -q "^$MISSION_NB CHECK_OK" "$GSH_CONFIG/missions.log" &&
    ! [ -e "$MISSION_DIR/skip" ] &&
    ! [ -e "$MISSION_DIR/skip.txt" ] &&
    ! admin_mode
  then
    __log_action "$MISSION_NB" "SKIP:AUTH_FAILURE"
    return 1
  fi
  __log_action "$MISSION_NB" "SKIP"
  export GSH_LAST_ACTION='skip'
  __gsh_clean "$MISSION_NB"
  color_echo yellow "$(eval_gettext 'Mission $MISSION_NB has been cancelled.')" >&2

  __gsh_start $((10#$MISSION_NB + 1))
}

# applies auto.sh script, if it exists
_gsh_auto() {
  local MISSION_NB="$(_gsh_pcm)"

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(missiondir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/auto.sh" ]
  then
    echo "$(eval_gettext "Error: mission \$MISSION_NB doesn't have an auto script.")" >&2
    return 1
  fi

  if ! admin_mode
  then
    __log_action "$MISSION_NB" "AUTO:AUTH_FAILURE"
    return 1
  fi
  __log_action "$MISSION_NB" "AUTO"
  mission_source "$MISSION_DIR/auto.sh"
  return 0
}


# check completion of a mission given by its number
_gsh_check() {
  local MISSION_NB="$(_gsh_pcm)"

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(missiondir "$MISSION_NB")"

  mission_source "$MISSION_DIR/check.sh"
  local exit_status=$?

  if [ "$exit_status" -eq 0 ]
  then
    echo
    color_echo green "$(eval_gettext 'Congratulations, mission $MISSION_NB has been successfully completed!')"
    echo

    if [ -f "$MISSION_DIR/treasure.sh" ]
    then
      # Record the treasure to be loaded by GameShell's gshrc.
      TREASURE_FILE=$GSH_CONFIG/treasure_$(printf "%04d" "$MISSION_NB")_$(basename "$MISSION_DIR"/).sh
      echo "export TEXTDOMAIN=\"$(textdomainname "$MISSION_DIR")\"" > "$TREASURE_FILE"
      cat "$MISSION_DIR/treasure.sh" >> "$TREASURE_FILE"
      echo "export TEXTDOMAIN=gsh" >> "$TREASURE_FILE"
      unset TREASURE_FILE

      # Display the text message (if it exists).
      if [ -f "$MISSION_DIR/treasure-msg.sh" ]
      then
        local tmp_treasure_file=$(mktemp)
        mission_source "$MISSION_DIR/treasure-msg.sh" > "$tmp_treasure_file"
        if [ -s "$tmp_treasure_file" ]
        then
          echo
          treasure_message "$tmp_treasure_file"
          echo
        fi
        rm -rf "$tmp_treasure_file"
      elif [ -f "$MISSION_DIR/treasure-msg.txt" ]
      then
        echo
        treasure_message "$MISSION_DIR/treasure-msg.txt"
        echo
      else
        local file_msg="$(TEXTDOMAIN="$(textdomainname "$MISSION_DIR")" eval_gettext '$MISSION_DIR/treasure-msg/en.txt')"
        if [ -f "$file_msg" ]
        then
          echo
          treasure_message "$file_msg"
          echo
        fi
      fi

      # Load the treasure in the current shell.
      mission_source "$MISSION_DIR/treasure.sh"

      #sourcing the file isn't very robust as the "gsh check" may happen in a subshell!
      if ! . mainshell.sh
      then
        echo "$(gettext "Warning: the file 'treasure.sh' was sourced from a subshell.
You should use the command
  \$ gsh reset")" >&2
      fi
    fi

    __gsh_clean "$MISSION_NB"

    __log_action "$MISSION_NB" "CHECK_OK"
    export GSH_LAST_ACTION='check_true'

    if [ -n "$GSH_AUTOSAVE" ] && [ "$GSH_AUTOSAVE" != "0" ]
    then
      __save
    fi

    __gsh_start $((10#$MISSION_NB + 1))
    return 0
  else
    echo
    color_echo red "$(eval_gettext "Sorry, mission \$MISSION_NB hasn't been completed.")"
    echo

    __gsh_clean "$MISSION_NB"
    __log_action "$MISSION_NB" "CHECK_OOPS"
    export GSH_LAST_ACTION='check_false'

    if [ -n "$GSH_AUTOSAVE" ] && [ "$GSH_AUTOSAVE" != "0" ]
    then
      __save
    fi

    __gsh_start "$MISSION_NB"
    return 255
  fi
}

__gsh_clean() {
  local MISSION_NB
  if [ -z "$1" ]
  then
    MISSION_NB="$(_gsh_pcm)"
  else
    MISSION_NB=$1
  fi

  if [ -z "$MISSION_NB" ]
  then
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(missiondir "$MISSION_NB")"

  if [ -f "$MISSION_DIR/clean.sh" ]
  then
    mission_source "$MISSION_DIR/clean.sh"
  fi
  unset GSH_LAST_ACTION
}


__save() {
  ! [ -d "$GSH_ROOT/.git" ] || return

  # GSH_SAVEFILE is defined on first save
  if [ -z "$GSH_SAVEFILE" ]
  then
    export GSH_SAVEFILE
    case "$GSH_SAVEFILE_MODE" in
      "index")
        # get extension
        EXT=${GSH_EXEC_FILE##*.}
        # remove extension and -save suffix
        GSH_SAVEFILE=$GSH_EXEC_DIR/${GSH_EXEC_FILE%.*}
        GSH_SAVEFILE=${GSH_SAVEFILE%-save*}
        INDEX=""
        while [ -e "$GSH_SAVEFILE-save$INDEX.$EXT" ]
        do
          [ -n "$INDEX" ] || INDEX=0
          INDEX=$(echo "000$((10#$INDEX + 1))" | tail -c -4)
        done
        GSH_SAVEFILE="$GSH_SAVEFILE-save$INDEX.$EXT"
      ;;

    "simple")
      # get extension
      EXT=${GSH_EXEC_FILE##*.}
      # remove extension and -save suffix (if present)
      GSH_SAVEFILE=$GSH_EXEC_DIR/${GSH_EXEC_FILE%.*}
      GSH_SAVEFILE=${GSH_SAVEFILE%-save*}
      # add -save suffix
      GSH_SAVEFILE="$GSH_SAVEFILE-save.$EXT"
      ;;

    "overwrite")
      GSH_SAVEFILE=$GSH_EXEC_DIR/$GSH_EXEC_FILE
      ;;

    esac
  fi
  _gsh_save "$GSH_SAVEFILE"
}


_gsh_assert_check() {
  local MISSION_NB="$(_gsh_pcm)"

  local expected=$1
  if [ "$expected" != "true" ] && [ "$expected" != "false" ]
  then
    echo "$(eval_gettext "Error: _gsh_assert_check only accept 'true' and 'false' as argument.")" >&2
    return 1
  fi
  local msg=$3

  local MISSION_DIR="$(missiondir "$MISSION_NB")"

  mission_source "$MISSION_DIR/check.sh"
  local exit_status=$?

  local nb_tests=$(cat "$GSH_TMP/nb_tests")
  nb_tests=$((nb_tests+1))
  echo "$nb_tests" > "$GSH_TMP/nb_tests"
  local nb_failed_tests=$(cat "$GSH_TMP/nb_failed_tests")

  if [ "$expected" = "true" ] && [ "$exit_status" -ne 0 ]
  then
    nb_failed_tests=$((nb_failed_tests+1))
    echo "$nb_failed_tests" > "$GSH_TMP/nb_failed_tests"
    color_echo red "$(eval_gettext 'test $nb_tests failed') (expected check 'true')"
    [ -n "$msg" ] && echo "$msg"
  elif [ "$expected" = "false" ] && [ "$exit_status" -eq 0 ]
  then
    nb_failed_tests=$((nb_failed_tests+1))
    echo "$nb_failed_tests" > "$GSH_TMP/nb_failed_tests"
    color_echo red "$(eval_gettext 'test $nb_tests failed') (expected check 'false')"
    [ -n "$msg" ] && echo "$msg"
  fi

  export GSH_LAST_ACTION="assert"
  __gsh_clean "$MISSION_NB"
  __gsh_start --quiet "$MISSION_NB"
}


_gsh_assert() {
  local condition=$1
  if [ "$condition" = "check" ]
  then
    shift
    _gsh_assert_check "$@"
    return
  fi
  local msg=$2

  local nb_tests=$(cat "$GSH_TMP/nb_tests")
  echo "$(( nb_tests + 1))" > "$GSH_TMP/nb_tests"

  if ! eval "$condition"
  then
    echo "$(( nb_failed_tests + 1))" > "$GSH_TMP/nb_failed_tests"
    color_echo red "$(eval_gettext 'test $nb_tests failed') (expected condition 'true')"
    [ -n "$msg" ] && echo "$msg"
  fi
}


_gsh_test() {
  local MISSION_NB="$(_gsh_pcm)"
  if [ -z "$MISSION_NB" ]
  then
    #shellcheck disable=SC2034
    local fn_name="${FUNCNAME[0]}"
    echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
    return 1
  fi

  local MISSION_DIR="$(missiondir "$MISSION_NB")"

  if ! [ -f "$MISSION_DIR/test.sh" ]
  then
    echo "$(eval_gettext "Error: mission \$MISSION_NB doesn't have a test script.")" >&2
    return 2
  fi

  echo 0 > "$GSH_TMP/nb_tests"
  echo 0 > "$GSH_TMP/nb_failed_tests"
  mission_source "$MISSION_DIR/test.sh"
  local ret

  local nb_tests=$(cat "$GSH_TMP/nb_tests")
  local nb_failed_tests=$(cat "$GSH_TMP/nb_failed_tests")

  if [ "$nb_failed_tests" = 0 ]
  then
    echo
    color_echo green "$(eval_gettext '$nb_tests successful tests')"
    echo
    ret=0
  else
    echo
    color_echo red "$(eval_gettext '$nb_failed_tests failures out of $nb_tests tests')"
    echo
    ret=255
  fi
  rm -f "$GSH_TMP/nb_tests" "$GSH_TMP/nb_failed_tests"
  return "$ret"
}


gsh() {
  local _TEXTDOMAIN=$TEXTDOMAIN
  export TEXTDOMAIN="gsh"
  local cmd=$1
  shift

  # should the command abort GameShell on failure (gsh test / gsh auto)
  if [ "$1" = "--abort" ]
  then
    local ABORT="true"
    shift
  fi

  local ret=0
  case $cmd in
    "check")
      _gsh_check
      ret=$?
      ;;
    "reset")
      export GSH_LAST_ACTION='reset'
      __gsh_clean
      _gsh_reset
      ;;
    "resetstatic")
      _gsh_resetstatic
      ;;
    "exit")
      _gsh_exit EXIT 0 "$@"
      ;;
    "skip")
      _gsh_skip
      ;;
    "auto")
      _gsh_auto
      ;;
    "hardreset")
      export GSH_LAST_ACTION='hardreset'
      __gsh_clean
      _gsh_hard_reset
      ;;
    "goto")
      if [ -z "$1" ]
      then
        echo "$(gettext "Error: the 'goto' command requires a mission number as argument.")" >&2
        return 1
      fi

      local MISSION_NB="$(_gsh_pcm)"
      if [ -z "$MISSION_NB" ]
      then
        #shellcheck disable=SC2034
        local fn_name="${FUNCNAME[0]}"
        echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
        return 1
      fi
      # allow going back to a previous mission
      if ! [ "$1" -le "$MISSION_NB" ] && ! admin_mode
      then
        __log_action "$MISSION_NB" "GOTO:AUTH_FAILURE"
        return 1
      fi
      __log_action "$MISSION_NB" "GOTO"

      export GSH_LAST_ACTION='goto'
      __gsh_clean
      __gsh_start "$@"
      ;;

    *)
      if command -v "_gsh_$cmd" >/dev/null
      then
        local MISSION_NB="$(_gsh_pcm)"
        if [ -z "$MISSION_NB" ]
        then
          #shellcheck disable=SC2034
          local fn_name="${FUNCNAME[0]}"
          echo "$(eval_gettext "Error: couldn't get mission number \$MISSION_NB (from \$fn_name)")" >&2
          return 1
        fi
        local MISSION_DIR="$(missiondir "$MISSION_NB")"

        MISSION_NB=$MISSION_NB MISSION_DIR=$MISSION_DIR "_gsh_$cmd" "$@"
        ret=$?
      else
        echo "$(eval_gettext "Error: unknown gsh command '\$cmd'.
Use one of the following commands:")  check, goal, help, reset" >&2
        export TEXTDOMAIN=$_TEXTDOMAIN
        unset _TEXTDOMAIN
        return 1
      fi
      ;;
  esac
  export TEXTDOMAIN=$_TEXTDOMAIN
  unset _TEXTDOMAIN
  [ -n "$ABORT" ] && [ "$ret" -eq 255 ] && exit 1
  return "$ret"
}

# vim: shiftwidth=2 tabstop=2 softtabstop=2
