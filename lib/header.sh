#!/usr/bin/env bash

if [ -n "$BASH_VERSION" ]
then
  # check if the file is being sourced
  if [ "$BASH_SOURCE" != "$0" ]
  then
    echo "GameShell must be run from a file, it cannot be sourced."
    return 1
  fi
  set -m
  current_shell=bash
elif [ -n "$ZSH_VERSION" ]
then
  case "${(M)zsh_eval_context}" in
    *file*)
      echo "GameShell must be run from a file, it cannot be sourced."
      return 1
    ;;
  esac
  current_shell=zsh
else
  echo "GameShell must be run with bash or zsh."
  return 1
fi

download_latest() {
  TARGET_DIR=$1
  if [ -z "$TARGET_DIR" ]
  then
    echo "Error: download_latest: no directory given" >&2
    exit 1
  fi

  TARGET="$TARGET_DIR/gameshell.sh"
  TMPFILE="$TARGET_DIR/gameshell.sh$$"
  if command -v wget >/dev/null
  then
    if wget -O "$TMPFILE" https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
    then
      mv "$TMPFILE" "$TARGET"
      chmod +x "$TARGET"
      echo "Latest version of GameShell downloaded to $TARGET_DIR/gameshell.sh"
      exit 0
    else
      rm -f "$TMPFILE"
      echo "Error: couldn't download or save the latest version of GameShell." >&2
      exit 1
    fi
  elif command -v curl >/dev/null
  then
    if curl -fo "$TMPFILE" https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
    then
      mv "$TMPFILE" "$TARGET"
      chmod +x "$TARGET"
      echo "Latest version of GameShell downloaded to $TARGET_DIR/gameshell.sh"
      exit 0
    else
      rm -f "$TMPFILE"
      echo "Error: couldn't download or save the latest version of GameShell." >&2
      exit 1
    fi
  fi
}

GSH_VERSION='developpment version'
GSH_LAST_CHECKED_MISSION=''

export GSH_EXEC_FILE=$(basename "$0")
export GSH_EXEC_DIR=$(dirname "$0")
GSH_EXEC_DIR=$(cd "$GSH_EXEC_DIR"; pwd -P)
# GSH_EXEC_DIR shouldn't be empty but consist at least of a "." (as per POSIX).
# just in case
GSH_EXEC_DIR=${GSH_EXEC_DIR:-.}
export GSH_EXTRACT_DIR=

CHECK_SAVEFILE="true"

while getopts ":hHIndDM:CRXUVqL:KBZc:FS:W:" opt
do
  case "$opt" in
    V)
      echo "GameShell $GSH_VERSION"
      if [ -n "$GSH_LAST_CHECKED_MISSION" ]
      then
        echo "saved game: [mission $GSH_LAST_CHECKED_MISSION]"
      fi
      exit 0
      ;;
    U)
      # I need to find out woth GSH_EXTRACT_DIR is first, so that I cannot
      # update here
      UPDATE_GAMESHELL="true"
      ;;
    W)
      GSH_EXTRACT_DIR=$OPTARG
      ;;
    X)
      EXTRACT_ONLY="true"
      ;;
    K)
      KEEP_DIR="true"
      ;;
    F)
      GSH_FORCE="true"
      ;;
    h | H | I)
      # used to avoid checking for more recent files
      CHECK_SAVEFILE="false"
      ;;

    S)
      # the next cases are used to check validity of parameters, to avoid
      # checking for savefiles the error message will be displayed with
      # appropriate language by start.sh
      case "$OPTARG" in
        "index" | "simple" | "overwrite")
          :
          ;;
        *)
          CHECK_SAVEFILE="false"
          ;;
      esac
      ;;
    M)
      case "$OPTARG" in
        passport | anonymous | debug)
          :
          ;;
        *)
          CHECK_SAVEFILE="false"
          ;;
      esac
      ;;

    '?')
      CHECK_SAVEFILE="false"
      ;;
    :)
      CHECK_SAVEFILE="false"
      ;;
    *)
      # ignore other options, they will be passed to start.sh
      ;;
  esac
done

# we need to save all the options and command line arguments in an bash/zsh
# array to give them back to the start.sh script
ARGV=( "$@" )
# and since we need to check the first argument, we need to get rid of all the
# options temporarily
shift $(($OPTIND - 1))

# get extract directory
if [ -n "$GSH_EXTRACT_DIR" ]
then
  # if the extract directory was explicitly given, check that it can be used
  if [ -d "$GSH_EXTRACT_DIR" ] && [ -r "$GSH_EXTRACT_DIR" ] && [ -w "$GSH_EXTRACT_DIR" ] && [ -x "$GSH_EXTRACT_DIR" ]
  then
    GSH_EXTRACT_DIR=$(cd "$GSH_EXTRACT_DIR"; pwd -P)
  else
    echo "Error: cannot extract to $GSH_EXTRACT_DIR" >&2
    exit 1
  fi
elif [ -w "$GSH_EXEC_DIR" ] && [ -x "$GSH_EXEC_DIR" ] && [ -w "$GSH_EXEC_FILE" ]
then
  # otherwise, we try using the GameShell script directory
  GSH_EXTRACT_DIR=$(cd "$GSH_EXEC_DIR"; pwd -P)
else
  # if the GameShell script directory doesn't have rwx permissions, we use
  # $HOME/.gameshell
  GSH_EXTRACT_DIR="$HOME/.gameshell"
  if ! mkdir -p "$HOME/.gameshell/" 2>/dev/null
  then
    echo "Error: couldn't create $GSH_EXTRACT_DIR directory" >&2
    exit 1
  fi
  GSH_EXTRACT_DIR=$(cd "$GSH_EXTRACT_DIR"; pwd -P)
  GSH_EXTRACT_DIR=${GSH_EXTRACT_DIR:-.}
fi

if [ "$UPDATE_GAMESHELL" = "true" ]
then
  download_latest "$GSH_EXTRACT_DIR"
fi

# get extension
EXT=${GSH_EXEC_FILE##*.}
# remove extension (if present)
GSH_NAME=${GSH_EXEC_FILE%.*}
# remove "-save" suffix (if present)
GSH_NAME=${GSH_NAME%-save*}
GSH_NAME=$(basename "$GSH_NAME")


if [ "$CHECK_SAVEFILE" = "true" ] && [ "$GSH_FORCE" != "true" ]
then
LAST_SAVEFILE=$(ls "$GSH_EXTRACT_DIR/$GSH_NAME-save"*".$EXT" 2>/dev/null | sort | tail -n 1)

if [ -n "$LAST_SAVEFILE" ] && [ "$GSH_EXTRACT_DIR/$GSH_EXEC_FILE" != "$LAST_SAVEFILE" ]
then
  echo "Warning: there is a more recent savefile"
  echo "You can"
  echo "  (1) keep the given file ("$GSH_EXEC_DIR/$GSH_EXEC_FILE")"
  echo "  (2) switch to the last savefile ("$LAST_SAVEFILE")"
  echo "  (3) abort"
  echo
  R=""
  while [ "$R" != 1 ] && [ "$R" != 2 ] && [ "$R" != 3 ]
  do
    printf "What do you want to do? [123] "
    read -r R
  done
fi
case "$R" in
  1)
    # do nothing, continue normally
    :
    ;;
  2)
    GSH_EXEC_FILE=$(basename "$LAST_SAVEFILE")
    GSH_EXEC_DIR=$(dirname "$LAST_SAVEFILE")
    # NOTE, GSH_EXTRACT_DIR is equal to the new GSH_EXEC_DIR in this case

    # remove extension (if present)
    GSH_NAME=${GSH_EXEC_FILE%.*}
    # remove "-save" suffix (if present)
    GSH_NAME=${GSH_NAME%-save}
    GSH_NAME=$(basename "$GSH_NAME")
    ;;
  3)
    exit 0
    ;;
  esac
fi


NB_LINES=$(awk '/^##START_OF_GAMESHELL_ARCHIVE##/ {print NR + 1; exit 0; }' "$GSH_EXEC_DIR/$GSH_EXEC_FILE")


if [ "$EXTRACT_ONLY" = "true" ]
then
  tail -n+"$NB_LINES" "$GSH_EXEC_DIR/$GSH_EXEC_FILE" > "$GSH_EXTRACT_DIR/${GSH_EXEC_FILE%.*}.tgz"
  echo "Archive saved in $GSH_EXTRACT_DIR/${GSH_EXEC_FILE%.*}.tgz"
  exit 0
fi


GSH_ROOT=$GSH_EXTRACT_DIR/$GSH_NAME
N=0
while [ -e "$GSH_ROOT" ]
do
  N=$((N+1))
  GSH_ROOT=$(echo "$GSH_ROOT" | sed 's/\.[0-9]*$//')
  GSH_ROOT="$GSH_ROOT.$N"
done
mkdir -p "$GSH_ROOT"
# check that the directory has been created
if ! [ -d "$GSH_ROOT" ]
then
  echo "Error: couldn't create temporary directory '$GSH_ROOT'" >&2
  return 1
fi
# and that it is empty
if [ "$(find "$GSH_ROOT" -print | head -n2 | wc -l)" -ne 1 ]
then
  echo "Error: temporary directory '$GSH_ROOT' is not empty." >&2
  return 1
fi
# and add a safeguard so we can check we are not removing another directory
touch "$GSH_ROOT/.gsh_root-$$"

# add a .save file so that we save the directory into a self extracting archive
# when exiting
touch "$GSH_ROOT/.save"

tail -n+"$NB_LINES" "$GSH_EXEC_DIR/$GSH_EXEC_FILE" > "$GSH_ROOT/gameshell.tgz"
tar -zx -C "$GSH_ROOT" -f "$GSH_ROOT/gameshell.tgz"
rm "$GSH_ROOT/gameshell.tgz"

# the archive should extract into a directory, move everything to GSH_ROOT
TMP_ROOT=$(find "$GSH_ROOT" -maxdepth 1 -path "$GSH_ROOT/*" -type d | head -n1)
mv "$TMP_ROOT"/* "$GSH_ROOT"
mv "$TMP_ROOT"/.[!.]* "$GSH_ROOT" 2>/dev/null
rmdir "$TMP_ROOT"

###
# remove root directory, with some minor failsafe
_remove_root() {
  trap - CHLD
  ret=$1

  if [ "$KEEP_DIR" != "true" ]
  then
    # some sanity checking to make sure we remove the good directory
    if ! [ -e "$GSH_ROOT/.gsh_root-$$" ]
    then
      echo "Error: I don't want to remove directory $GSH_ROOT!" >&2
      exit 1
    fi
    chmod -R 777 "$GSH_ROOT"
    rm -rf "$GSH_ROOT"
  fi
  exit "$ret"
}


###
# start GameShell
# I want to run the _remove_root command when the (only) child terminates
# In bash, I can trap SIGCHLD, but for some reason, we cannot trap SIGCHLD when
# the main process receives SIGHUP (for example when the terminal is closed),
# unless we trap SIGHUP as well. (Even an empty trap is OK.)
#
# This doesn't work for zsh, so I need to call _remove_root explicitly. In the case of
# SIGHUP, the child is terminated and the main process continues normally, so
# that _remove_root is indeed executed...

trap "" HUP SIGHUP
trap '_remove_root $?' CHLD
# restore save arguments
set -- "${ARGV[@]}"
$current_shell "$GSH_ROOT/start.sh" -C "$@"

# zsh doesn't receive SIGCHLD but seems to always continue, even in the case of
# SIGHUP. We thus call _remove_root explicitly.
_remove_root $?

##START_OF_GAMESHELL_ARCHIVE##
