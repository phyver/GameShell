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


export GSH_WORKING_DIR=$(pwd -P)

export GSH_ROOT="$(dirname "$0")"
# shellcheck source=scripts/gsh_gettext.sh
. "$GSH_ROOT/scripts/gsh_gettext.sh"
# shellcheck source=lib/profile.sh
. "$GSH_ROOT/lib/profile.sh"
# shellcheck source=lib/mission_source.sh
. "$GSH_ROOT/lib/mission_source.sh"

display_full_help() {
  sed -e "s/\$GSH_EXEC_FILE/$GSH_EXEC_FILE/" \
    -e "s/\$GSH_INDEX_FILES/$(echo "$GSH_INDEX_FILES" | sed "s/:/, /g")/" \
    "$(eval_gettext "\$GSH_ROOT/i18n/start-full-help/en.txt")"
}

display_help() {
  sed -e "s/\$GSH_EXEC_FILE/$GSH_EXEC_FILE/" \
    -e "s/\$GSH_INDEX_FILES/$(echo "$GSH_INDEX_FILES" | sed "s/:/, /g")/" \
    "$(eval_gettext "\$GSH_ROOT/i18n/start-help/en.txt")"
}


# list of index files (default: only default.idx)
export GSH_INDEX_FILES=default.idx

# possible values: index, simple (default), overwrite
export GSH_SAVEFILE_MODE="simple"
export GSH_AUTOSAVE=1
export GSH_COLOR="OK"
GSH_MODE="ANONYMOUS"
GSH_EXPLICIT_LANGUAGE="false"
# if GSH_NO_GETTEXT is non-empty, gettext won't be used anywhere, the only language will thus be English
# export GSH_NO_GETTEXT=1  # DO NOT CHANGE OR REMOVE THIS LINE, it is used by utils/archive.sh
RESET=""
while getopts ":hHIndDM:CRXUVqL:KBZc:FS:" opt
do
  case $opt in
    S)
      case "$OPTARG" in
        "index" | "simple" | "overwrite")
          GSH_SAVEFILE_MODE=$OPTARG
          ;;
        *)
          echo "$(gettext "Error: save mode can only be 'index', 'simple' or 'overwrite'")" >&2
          exit 1
          ;;
      esac
      ;;
    h)
      display_help
      exit 0
      ;;
    H)
      display_full_help
      exit 0
      ;;
    I)
      gettext "Available index files: " >&2
      echo "$GSH_INDEX_FILES" | sed "s/:/, /g" >&2
      exit 0
      ;;
    n)
      GSH_COLOR=""
      ;;
    M)
      case "$OPTARG" in
        passport)
          GSH_MODE="PASSPORT"
          ;;
        anonymous)
          GSH_MODE="ANONYMOUS"
          ;;
        debug)
          GSH_MODE="debug"
          ;;
        *)
          echo "$(eval_gettext "Error: invalid mode (option -M): '-\$OPTARG'")" >&2
          exit 1
      esac
      ;;
    d)
      GSH_MODE="DEBUG"
      ;;
    D)
      GSH_MODE="DEBUG"
      export GSH_VERBOSE_DEBUG="true"
      ;;
    q)
      export GSH_QUIET_INTRO="true"
      ;;
    C)
      RESET="FALSE"
      ;;
    R)
      RESET="TRUE"
      ;;
    L)
      if [ -z "$OPTARG" ]
      then
        export GSH_NO_GETTEXT=1
      else
        export LANGUAGE="$OPTARG"     # only works on GNU systems
        unset GSH_NO_GETTEXT
      fi
      GSH_EXPLICIT_LANGUAGE="true"
      ;;
    V)
      # when lib/header.sh sees the -V flag, it displays the version and exits,
      # so the next case isn't used.
      # this is only used when running GameShell directly from start.sh
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1
      then
        echo "GameShell $(git describe --always --dirty)"
      fi

      echo "run directly from start.sh"
      exit 0;
      ;;
    B)
      export GSH_SHELL=bash
      ;;
    Z)
      export GSH_SHELL=zsh
      ;;
    c)
      GSH_COMMAND=$OPTARG
      ;;
    X | U)
      echo "$(gettext "Error: this option is only available from an executable archive!")" >&2
      exit 1
      ;;
    '?')
      echo "$(eval_gettext "Error: invalid option: '-\$OPTARG'")" >&2
      exit 1
      ;;
    :)
      echo "$(eval_gettext "Error: missing parameter for option: '-\$OPTARG'")" >&2
      exit 1
      ;;
    *)
      :  # other options are used by the self-extracting archive and passed on
         # we ignore them
      ;;
  esac
done
shift $((OPTIND - 1))

if [ $(id -u) -eq 0 ]
then
  echo "$(gettext "Error: you shouldn't run Gameshell as root!")" >&2
  exit 1
fi


# check we have a shell compatible with GameShell
if [ -z "$GSH_SHELL" ]
then
  if [ -n "$BASH_VERSION" ]
  then
    export GSH_SHELL=bash
  elif [ -n "$ZSH_VERSION" ]
  then
    export GSH_SHELL=zsh
  else
    case "$SHELL" in
      *bash)
        export GSH_SHELL=$SHELL
        ;;
      *zsh)
        export GSH_SHELL=$SHELL
        ;;
      *)
        echo "$(eval_gettext "Error: unknown shell '\$SHELL'.
Run GameShell with either bash or zsh.")" >&2
        exit 1
        ;;
    esac
  fi
fi


_passport() {
  local PASSPORT=$1
  NOM=""
  while [ -z "$NOM" ]
  do
    printf "$(gettext "Player's name:") "
    read -r NOM
  done
  EMAIL=""
  while [ -z "$EMAIL" ]
  do
    printf "$(gettext "Player's email:") "
    read -r EMAIL
  done
  echo "  $NOM <$EMAIL>" > "$PASSPORT"
}

_confirm_passport() {
  local PASSPORT=$1
  echo "======================================================="
  cat "$PASSPORT"
  echo "======================================================="
  while true
  do
    printf "$(gettext "Is this information correct? [Y/n]") "
    read -r OK
    echo
    if [ -z "$OK" ] || [ "$OK" = "$(gettext "y")" ] || [ "$OK" = "$(gettext "Y")" ]
    then
      return 0
    elif [ "$OK" = "$(gettext "n")" ] || [ "$OK" = "$(gettext "N")" ]
    then
      return 1
    fi
  done
}

progress() {
  if [ -z "$progress_I" ]
  then
    progress_filename=$GSH_ROOT/lib/ascii-art/titlescreen
    local N=$(wc -l "$GSH_CONFIG/index.idx" | awk '{print $1}')
    local size=$(wc -c "$progress_filename" | awk '{print $1}')
    progress_delta=$((size/N + 1))
    # head -c$((progress_delta - 1)) $progress_filename => not POSIX compliant
    dd if="$progress_filename" bs="$progress_delta" count=1 2>/dev/null
    progress_I=1
  else
    # tail -c+$((progress_I * progress_delta)) $progress_filename | head -c$progress_delta => not POSIX compliant
    dd if="$progress_filename" bs="$progress_delta" skip="$progress_I" count=1 2>/dev/null
    progress_I=$((progress_I+1))
  fi
}

progress_finish() {
  # tail -c+$((progress_I*progress_delta)) $progress_filename => not POSIX compliant
  dd if="$progress_filename" bs="$progress_delta" skip="$progress_I" 2>/dev/null
  unset progress_filename progress_delta progress_I
  # show cursor and enable echo of keystrokes
}


init_gsh() {

  ADMIN_SALT='EsULESDXKFpLRjZcIRiVnazJfQcwQDEz'            # a random (but fixed) salt
  ADMIN_HASH='cb1b87bc6282a94ff3f37eb47a2aa3dc069341d0'    # default for "$GSH_SALT gsh"

  # message when data from a previous play is found. We can either
  #    - restart a new game
  #    - continue the previous game
  if [ -e "$GSH_CONFIG" ]
  then

    while [ -z "$RESET" ]
    do
      local r
      printf "$(eval_gettext 'The directory $GSH_CONFIG contains meta-data from a previous game.
Do you want to remove it and start a new game? [y/N]') "
      read -r r
      if [ "$r" = "$(gettext "y")" ] || [ "$r" = "$(gettext "Y")" ]
      then
        RESET=TRUE
        echo
      fi
      if [ -z "$r" ] || [ "$r" = "$(gettext "n")" ] || [ "$r" = "$(gettext "N")" ]
      then
        RESET=FALSE
        echo
      fi
    done

  else
    # if no data is found, we need to initialize a new game
    RESET=TRUE
  fi

  if [ "$RESET" = FALSE ]
  then
    if [ "$#" -gt 0 ] || [ "$GSH_EXPLICIT_LANGUAGE" = true ]
    then
      args=$*
      [ "$#" -gt 0 ] && echo "$(eval_gettext 'Warning: command line arguments are ignored when continuing a game ($args)')" >&2
      args=$LANGUAGE
      [ "$GSH_EXPLICIT_LANGUAGE" = true ] &&  echo "$(eval_gettext 'Warning: language is ignored when continuing a game ($args)')" >&2
      echo "$(gettext 'Press Enter to continue.')" >&2
      read -r _
    fi
    return 1
  fi

  ### if we're here, we need to reset a new game

  # remove all the game data
  rm -rf "$GSH_HOME"
  rm -rf "$GSH_CONFIG"
  rm -rf "$GSH_TMP"
  rm -rf "$GSH_BIN"
  rm -rf "$GSH_SBIN"

  # recreate them
  mkdir -p "$GSH_HOME"

  mkdir -p "$GSH_CONFIG"
  awk -v seed_file="$GSH_CONFIG/PRNG_seed" 'BEGIN { srand(); printf("%s", int(2^32 * rand())) > seed_file; }'

  # save current locale
  locale > "$GSH_CONFIG"/config.sh
  echo "export GSH_MODE=$GSH_MODE" >> "$GSH_CONFIG"/config.sh
  # TODO save other config (color ?)

  # save hash for admin password
  if [ -n "$ADMIN_HASH" ]
  then
    echo "$ADMIN_HASH" > "$GSH_CONFIG/admin_hash"
    echo "$ADMIN_SALT" > "$GSH_CONFIG/admin_salt"
  fi

  mkdir -p "$GSH_BIN"
  mkdir -p "$GSH_SBIN"
  mkdir -p "$GSH_TMP"

  # id of player
  PASSPORT="$GSH_CONFIG/passport.txt"

  while true
  do
    # Reading the player name (if in passport mode).
    case "$GSH_MODE" in
      DEBUG)
        echo "DEBUG MODE" >> "$PASSPORT"
        break
        ;;
      ANONYMOUS)
        echo "ANONYMOUS MODE" >> "$PASSPORT"
        break
        ;;
      PASSPORT)
        _passport "$PASSPORT"
        ;;
    esac

    # Check that the information is correct.
    _confirm_passport "$PASSPORT" && break
  done

  # some random part added to the file so that GSH_UID is randomized
  printf '==========\nrandom salt: %d\n' "$("$GSH_ROOT/scripts/RANDOM")" >> "$PASSPORT"

  # Generation of a unique identifier for the the player.
  export GSH_UID="$(checksum < "$PASSPORT" | cut -c 1-40)"
  echo "GSH_UID=$GSH_UID" >> "$PASSPORT"
  echo "$GSH_UID" > "$GSH_CONFIG/uid"

  # save system config, in case of problems
  _gsh_systemconfig > "$GSH_CONFIG/system"

  ### generate GameShell translation files
  # NOTE: nullglob don't expand in POSIX sh and there is no shopt -s nullglob as in bash
  if [ -z "$GSH_NO_GETTEXT" ] && command -v msgfmt >/dev/null && [ -n "$(find "$GSH_ROOT/i18n" -maxdepth 1 -name '*.po' | head -n1)" ]
  then
    for PO_FILE in "$GSH_ROOT"/i18n/*.po; do
      PO_LANG=$(basename "$PO_FILE" .po)
      MO_FILE="$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo"
      if ! [ -f "$MO_FILE" ] || [ "$PO_FILE" -nt "$MO_FILE" ]
      then
        mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
        msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$TEXTDOMAIN.mo" "$PO_FILE"
      fi
    done
  fi

  # hide cursor and disable echoing of keystrokes
  tput civis 2>/dev/null
  stty -echo 2>/dev/null
  # those traps will be redefined in lib/gsh.sh
  trap "tput cnorm 2>/dev/null; stty echo 2>/dev/null; echo" INT TERM EXIT

  # Clear the screen.
  if [ "$GSH_MODE" = "DEBUG" ]
  then
    printf "[MISSION INITIALISATION]" >&2
  elif [ -z "$GSH_QUIET_INTRO" ]
  then
    clear
  fi

  make_index "$@" | sed -e "s;$GSH_MISSIONS;.;" > "$GSH_CONFIG/index.idx"

  if [ "$GSH_MODE" != "DEBUG" ]
  then
    cat "$GSH_LIB/ascii-art/GameShell.txt"
    echo
  fi
  # Installing all missions.
  local MISSION_NB=1      # current mission number
  local MISSION_SUB_NB="" # when a dummy mission is found, as a "sub-number" as well
  local FULL_NB           # the 2 together
  while read -r MISSION_DIR
  do
    case $MISSION_DIR in
      "" | "#"* )
        continue
        ;;
      "!"*)
        MISSION_DIR=$(echo "$MISSION_DIR" | cut -c2-)
        if [ -z "$MISSION_SUB_NB" ]
        then
          MISSION_SUB_NB=1
        else
          MISSION_SUB_NB=$((MISSION_SUB_NB + 1))
        fi
        ;;
      *)
        MISSION_SUB_NB=""
        ;;
    esac
    FULL_NB=$(printf "%04d" $MISSION_NB)
    [ -n "$MISSION_SUB_NB" ] && FULL_NB="$FULL_NB-$(printf "%04d" "$MISSION_SUB_NB")"

    export MISSION_DIR
    MISSION_DIR=$GSH_MISSIONS/$MISSION_DIR

    # To be used as TEXTDOMAIN environment variable for the mission.
    export DOMAIN=$(textdomainname "$MISSION_DIR")

    # Preparing the locales
    if [ -z "$GSH_NO_GETTEXT" ] && command -v msgfmt >/dev/null && [ -d "$MISSION_DIR/i18n" ]
    then
      # NOTE: shopt -s nullglob doesn't exist in POSIX sh
      if [ -n "$(find "$MISSION_DIR/i18n" -maxdepth 1 -name '*.po' | head -n1)" ]
      then
        for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
          PO_LANG=$(basename "$PO_FILE" .po)
          MO_FILE="$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo"
          if ! [ -f "$MO_FILE" ] || [ "$PO_FILE" -nt "$MO_FILE" ]
          then
            mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
            msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
          fi
        done
      fi
    fi

    # Setting up the binaries
    if [ -d "$MISSION_DIR/sbin" ]
    then
      # NOTE: shopt -s nullglob doesn't exist in POSIX sh
      if [ -n "$(find "$MISSION_DIR/sbin" -maxdepth 1 -type f -name '*' | head -n1)" ]
      then
        for BIN_FILE in "$MISSION_DIR"/sbin/*; do
          [ -f "$BIN_FILE" ] && [ -x "$BIN_FILE" ] && copy_bin "$BIN_FILE" "$GSH_SBIN"
        done
      fi
    fi
    if [ -d "$MISSION_DIR/bin" ]
    then
      # NOTE: shopt -s nullglob doesn't exist in POSIX sh
      if [ -n "$(find "$MISSION_DIR/bin" -maxdepth 1 -type f -name '*' | head -n1)" ]
      then
        for BIN_FILE in "$MISSION_DIR"/bin/*; do
          [ -f "$BIN_FILE" ] && [ -x "$BIN_FILE" ] && copy_bin "$BIN_FILE" "$GSH_BIN"
        done
      fi
    fi

    # source the static part of the mission
    if [ -f "$MISSION_DIR/static.sh" ]
    then
      mission_source "$MISSION_DIR/static.sh"
    fi

    # copy all the shell config files of the mission
    if [ -f "$MISSION_DIR/gshrc" ]
    then
      GSHRC_FILE=$GSH_CONFIG/gshrc_${FULL_NB}_$(basename "$MISSION_DIR").sh
      {
        echo "export MISSION_DIR=\"$MISSION_DIR\"";
        echo "export TEXTDOMAIN=\"$DOMAIN\"";
      } >"$GSHRC_FILE"
      cat "$MISSION_DIR/gshrc" >> "$GSHRC_FILE"
      echo "export TEXTDOMAIN=gsh" >> "$GSHRC_FILE"
      unset GSHRC_FILE
    fi

    if [ "$GSH_MODE" = "DEBUG" ] && [ "$GSH_VERBOSE_DEBUG" = true ]
    then
      printf '    GSH: mission %3d -> %s\n' "$MISSION_NB" "\$GSH_MISSIONS/${MISSION_DIR#$GSH_MISSIONS/}" >&2
    elif [ "$GSH_MODE" = "DEBUG" ]
    then
      printf "." >&2
    else
      progress
    fi

    [ -z "$MISSION_SUB_NB" ] && MISSION_NB=$((MISSION_NB+1))

  done < "$GSH_CONFIG/index.idx"
  if [ "$MISSION_NB" -eq 1 ]
  then
    echo "$(gettext "Error: no mission was found!
Aborting.")" >&2
    exit 1
  fi
  if [ "$GSH_MODE" = "DEBUG" ]
  then
    [ "$GSH_VERBOSE_DEBUG" != true ] && echo "[DONE]" >&2
  else
    progress_finish
    # show cursor back
    tput cnorm 2>/dev/null
    if [ -z "$GSH_QUIET_INTRO" ]
    then
      echo
      printf "$(gettext "Press Enter to continue.")"
      stty -echo 2>/dev/null    # ignore errors, in case input comes from a redirection
      read
      stty echo 2>/dev/null    # ignore errors, in case input comes from a redirection
      clear
    else
      echo
    fi
  fi
  unset MISSION_DIR MISSION_NB

  # show cursor and re-enable echoing of keystrokes
  tput cnorm 2>/dev/null
  stty echo 2>/dev/null
}

#######################################################################

init_gsh "$@"

# change the HOME dir, but save the "real" one in a variable
export REAL_HOME="$HOME"
export HOME="$GSH_HOME"

# set TMPDIR, that may be used by external scripts like mktemp
export TMPDIR="$GSH_TMP"


### test some of the scripts
if ! sh "$GSH_ROOT/lib/bin_test.sh"
then
  echo "$(gettext "Error: a least one base function is not working properly.
Aborting!")"
  exit 1
fi

cd "$GSH_HOME"
export GSH_UID=$(cat "$GSH_CONFIG/uid")
date "+%Y-%m-%d %H:%M:%S" | sed 's/^/#>>> /' >> "$GSH_CONFIG/missions.log"

# if the user uses a special TERMINFO entry, it might not be found because
# GameShell redefines HOME
if [ -z "$TERMINFO" ]
then
  export TERMINFO=$REAL_HOME/.terminfo
else
  # this might be run with sh, which doesn't have variable string substitution
  TERMINFO=$(echo "$TERMINFO" | sed -e "s#~#$REAL_HOME#g")
fi

generate_rcfile
if [ -n "$GSH_COMMAND" ]
then
  # NOTE, with "-c", environment isn't inherited by bash / zsh
  # we need to re-source profile.sh
  # exec $GSH_SHELL -i -c "GSH_ROOT=\"$GSH_ROOT\"
  #                        . \"\$GSH_ROOT/lib/profile.sh\"
  #                        $GSH_COMMAND"

  # NOTE, the above works in bash, but when running the following script with
  # GSH_SHELL=zsh, it fails with "zsh: suspended (tty output)"
  # ======== script =======
  # #!/usr/bin/env sh
  # ./gameshell.sh -qc "gsh exit"; ./gameshell.sh -qc "gsh exit"
  # =======================
  # FIX: don't start the shell in interactive mode, and source the rcfile
  # explicitly
  case "$GSH_SHELL" in
    *bash)
      RC_FILE=.bashrc
      ;;
    *zsh)
      RC_FILE=.zshrc
      ;;
  esac

  # start GameShell
  exec $GSH_SHELL -c "export GSH_NON_INTERACTIVE=1
                       GSH_ROOT=\"$GSH_ROOT\"
                       . \"\$GSH_ROOT/lib/profile.sh\"
                       . \"\$GSH_HOME/$RC_FILE\"
                       $GSH_COMMAND"
else
  # start GameShell
  exec $GSH_SHELL
fi

# vim: shiftwidth=2 tabstop=2 softtabstop=2
