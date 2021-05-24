#!/usr/bin/env bash

# shellcheck disable=SC2005

source gettext.sh

export GSH_ROOT="$(dirname "$0")"
source "$GSH_ROOT/lib/common.sh"

display_help() {
  cat "$(eval_gettext "\$GSH_ROOT/i18n/start-help/en.txt")"
}


export GSH_COLOR="OK"
GSH_MODE="ANONYMOUS"
RESET=""
while getopts ":hcnPdDACRXqL:K" opt
do
  case $opt in
    h)
      display_help
      exit 0
      ;;
    n)
      GSH_COLOR=""
      ;;
    c)
      GSH_COLOR="OK"
      ;;
    P)
      GSH_MODE="PASSPORT"
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
    A)
      GSH_MODE="ANONYMOUS"
      ;;
    C)
      RESET="FALSE"
      ;;
    R)
      RESET="TRUE"
      ;;
    L)
      if locale | grep "LANGUAGE" >/dev/null
      then
        export LANGUAGE=$OPTARG
      else
        if locale -a | grep -x "$OPTARG" >/dev/null
        then
          export LC_MESSAGES=$OPTARG
        else
          echo "Unknown locale: '$OPTARG'." >&2
          echo "You can run 'locale -a' to get a list of all locales installed on your system." >&2
          locale -a | grep "$OPTARG" && echo "The above locales might be relevant..." >&2
          exit 1
        fi
      fi
      ;;
    X)
      echo "$(gettext "Error: this option is only available from an executable archive!")" >&2
      exit 1
      ;;
    K)
      :  # used by the self-extracting archive
      ;;
    *)
      echo "$(eval_gettext "Error: invalid option: '-\$OPTARG'")" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))


_passport() {
  local PASSPORT=$1
  NOM=""
  while [ -z "$NOM" ]
  do
    read -erp "$(gettext "Player's name:") " NOM
  done
  EMAIL=""
  while [ -z "$EMAIL" ]
  do
    read -erp "$(gettext "Player's email:") " EMAIL
  done
  echo "  $NOM <$EMAIL>" >> "$PASSPORT"
}

_confirm_passport() {
  local PASSPORT=$1
  echo "======================================================="
  cat "$PASSPORT"
  echo "======================================================="
  while true
  do
    read -erp "$(gettext "Is this information correct? [Y/n]") " OK
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

progress_bar() {
  # hide cursor
  tput civis 2> /dev/null
  trap "tput cnorm 2> /dev/null;echo;exit 1" INT TERM QUIT
  if [ -z "$progress_I" ]
  then
    progress_filename=$GSH_ROOT/lib/ascii-art/titlescreen
    local N=$(wc -l "$GSH_CONFIG/index.txt" | awk '{print $1}')
    local size=$(wc -c $progress_filename | awk '{print $1}')
    progress_delta=$((size/N + 1))
    # head -c$((progress_delta - 1)) $progress_filename => not POSIX compliant
    dd if="$progress_filename" bs="$progress_delta" count=1 2> /dev/null
    progress_I=1
  else
    # tail -c+$((progress_I * progress_delta)) $progress_filename | head -c$progress_delta => not POSIX compliant
    dd if="$progress_filename" bs="$progress_delta" skip="$progress_I" count=1 2> /dev/null
    progress_I=$((progress_I+1))
  fi
}

progress_bar_finish() {
  tail -c+$((progress_I*progress_delta)) $progress_filename
  unset progress_filename progress_delta progress_I
  # show cursor
  tput cnorm 2> /dev/null
}


init_gsh() {

  ADMIN_HASH='b88968dc60b003b9c188cc503a457101b4087109'    # default for 'gsh'

  # message when data from a previous play is found. We can either
  #    - restart a new game
  #    - continue the previous game
  if [ -e "$GSH_CONFIG" ]
  then
    if [ -z "$RESET" ]
    then
      local r
      read -erp "$(eval_gettext 'The directory $GSH_CONFIG contains meta-data from a previous game.
Do you want to remove it and start a new game? [y/N]') " r
      [ "$r" = "$(gettext "y")" ] || [ "$r" = "$(gettext "Y")" ] || return 1

    elif [ "$RESET" = "FALSE" ]
    then
      return 1
    fi
  fi

  ### if we're here, we need to reset a new game

  # remove all the game data
  rm -rf "$GSH_HOME"
  rm -rf "$GSH_CONFIG"
  rm -rf "$GSH_VAR"
  rm -rf "$GSH_BASHRC"
  rm -rf "$GSH_BIN"
  rm -rf "$GSH_SBIN"

  # recreate them
  mkdir -p "$GSH_HOME"

  mkdir -p "$GSH_CONFIG"
  echo "# mission action date checksum" >> "$GSH_CONFIG/missions.log"

  mkdir -p "$GSH_BASHRC"
  cp "$GSH_LIB/bashrc" "$GSH_BASHRC"

  # save current locale
  locale | sed -e "s/^/export /" > "$GSH_BASHRC"/config.sh
  echo "export GSH_MODE=$GSH_MODE" >> "$GSH_BASHRC"/config.sh
  # TODO save other config (color ?)

  # save hash for admin password
  [ -n "$ADMIN_HASH" ] && echo "$ADMIN_HASH" > "$GSH_CONFIG/admin_hash"

  mkdir -p "$GSH_BIN"
  mkdir -p "$GSH_SBIN"

  mkdir -p "$GSH_VAR"


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

  printf "\n==========\nRANDOM=%d\n" $RANDOM >> "$PASSPORT"


  # Generation of a unique identifier for the the player.
  export GSH_UID="$(checksum < "$PASSPORT" | cut -c 1-40)"
  echo "GSH_UID=$GSH_UID" >> "$PASSPORT"
  echo "$GSH_UID" > "$GSH_CONFIG/uid"

  # save system config, in case of problems
  system_config > "$GSH_CONFIG/system"


  # Clear the screen.
  if [ "$GSH_MODE" = "DEBUG" ]
  then
    echo -n "[MISSION INITIALISATION]"
  else
    clear
  fi

  make_index "$@" | sed -e "s;$GSH_MISSIONS;.;" > "$GSH_CONFIG/index.txt"

  if [ "$GSH_MODE" != "DEBUG" ]
  then
    echo
    cat "$GSH_LIB/ascii-art/GameShell.txt"
    echo
  fi
  # Installing all missions.
  local MISSION_NB=1      # current mission number
  local MISSION_SUB_NB="" # when a dummy mission is found, as a "sub-number" as well
  local FULL_NB           # the 2 together
  while read MISSION_DIR
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
    if [ -d "$MISSION_DIR/i18n" ]
    then
      shopt -s nullglob
      for PO_FILE in "$MISSION_DIR"/i18n/*.po; do
        PO_LANG=$(basename "$PO_FILE" .po)
        MO_FILE="$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo"
        if ! [ -f "$MO_FILE" ] || [ "$PO_FILE" -nt "$MO_FILE" ]
        then
          mkdir -p "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES"
          msgfmt -o "$GSH_ROOT/locale/$PO_LANG/LC_MESSAGES/$DOMAIN.mo" "$PO_FILE"
        fi
      done
      shopt -u nullglob
    fi

    # Setting up the binaries
    if [ -d "$MISSION_DIR/sbin" ]
    then
      shopt -s nullglob
      for BIN_FILE in "$MISSION_DIR"/sbin/*; do
        [ -f "$BIN_FILE" ] && [ -x "$BIN_FILE" ] && copy_bin "$BIN_FILE" "$GSH_SBIN"
      done
      shopt -u nullglob
    fi
    if [ -d "$MISSION_DIR/bin" ]
    then
      shopt -s nullglob
      for BIN_FILE in "$MISSION_DIR"/bin/*; do
        [ -f "$BIN_FILE" ] && [ -x "$BIN_FILE" ] && copy_bin "$BIN_FILE" "$GSH_BIN"
      done
      shopt -u nullglob
    fi

    # source the static part of the mission
    if [ -f "$MISSION_DIR/static.sh" ]
    then
      mission_source "$MISSION_DIR/static.sh"
    fi

    # copy all the shell config files of the mission
    if [ -f "$MISSION_DIR/bashrc" ]
    then
      BASHRC_FILE=$GSH_BASHRC/bashrc_${FULL_NB}_$(basename "$MISSION_DIR").sh
      echo "export TEXTDOMAIN=$DOMAIN" > "$BASHRC_FILE"
      cat "$MISSION_DIR/bashrc" >> $BASHRC_FILE
      echo "export TEXTDOMAIN=gsh" >> "$BASHRC_FILE"
      unset BASHRC_FILE
    fi

    if [ "$GSH_MODE" = "DEBUG" ] && [ "$GSH_VERBOSE_DEBUG" = true ]
    then
      printf "\n%3d -> %s" "$MISSION_NB" "${MISSION_DIR#GSH_MISSIONS/}"
    elif [ "$GSH_MODE" = "DEBUG" ]
    then
      echo -n "."
    else
      progress_bar
    fi

    [ -z "$MISSION_SUB_NB" ] && MISSION_NB=$((MISSION_NB+1))

  done < "$GSH_CONFIG/index.txt"
  if [ "$MISSION_NB" -eq 1 ]
  then
    echo "$(gettext "Error: no mission was found!
Aborting.")"
    exit 1
  fi
  if [ "$GSH_MODE" = "DEBUG" ]
  then
    [ "$GSH_VERBOSE_DEBUG" = true ] && echo
    echo "[DONE]"
  else
    progress_bar_finish
    echo
    read -sern1 -p "$(gettext "Press any key to continue.")"
    clear
  fi
  unset MISSION_DIR MISSION_NB
}

#######################################################################

init_gsh "$@"
cd "$GSH_HOME"
export GSH_UID=$(cat "$GSH_CONFIG/uid")
# make sure the shell reads it's config file by making it interactive (-i)
exec bash --rcfile "$GSH_LIB/bashrc" -i

# vim: shiftwidth=2 tabstop=2 softtabstop=2
