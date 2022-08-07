#!/bin/bash

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

export GSH_EXEC_FILE=$(basename "$0")
export GSH_EXEC_DIR=$(dirname "$0")
GSH_EXEC_DIR=$(cd "$GSH_EXEC_DIR"; pwd -P)
# GSH_EXEC_DIR shouldn't be empty but consist at least of a "." (as per POSIX).
# just in case
GSH_EXEC_DIR=${GSH_EXEC_DIR:-.}

for arg in "$@"
do
  if [ "$arg" = "-U" ]
  then
    TARGET="$GSH_EXEC_DIR/gameshell.sh"
    TMPFILE="$GSH_EXEC_DIR/gameshell.sh$$"
    if command -v wget >/dev/null
    then
      if wget -O "$TMPFILE" https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
      then
        mv "$TMPFILE" "$TARGET"
        chmod +x "$TARGET"
        echo "Latest version of GameShell downloaded to $GSH_EXEC_DIR/gameshell.sh"
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
        echo "Latest version of GameShell downloaded to $GSH_EXEC_DIR/gameshell.sh"
        exit 0
      else
        rm -f "$TMPFILE"
        echo "Error: couldn't download or save the latest version of GameShell." >&2
        exit 1
      fi
    fi
  elif [ "$arg" = "-X" ]
  then
    GSH_EXTRACT="true"
  elif [ "$arg" = "-K" ]
  then
    KEEP_DIR="true"
  elif [ "$arg" = "-h" ]
  then
    # used to avoid checking for more recent files
    GSH_HELP="true"
  fi
done


# get extension
EXT=${GSH_EXEC_FILE##*.}
# remove extension (if present)
GSH_NAME=${GSH_EXEC_FILE%.*}
# remove "-save" suffix (if present)
GSH_NAME=${GSH_NAME%-save*}
GSH_NAME=$(basename "$GSH_NAME")


if [ "$GSH_HELP" != "true" ]
then
  LAST_SAVEFILE=$(ls "$GSH_EXEC_DIR/$GSH_NAME-save"*".$EXT" 2>/dev/null | sort | tail -n 1)

  if [ -n "$LAST_SAVEFILE" ] && [ "$GSH_EXEC_DIR/$GSH_EXEC_FILE" != "$LAST_SAVEFILE" ]
  then
    echo "Warning: there is a more recent savefile"
    echo "You can"
    echo "  (1) keep the given file ("$GSH_EXEC_FILE")"
    echo "  (2) switch to the last savefile ($(basename "$LAST_SAVEFILE"))"
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
      export GSH_EXEC_DIR=$(dirname "$LAST_SAVEFILE")
      GSH_EXEC_DIR=$(cd "$GSH_EXEC_DIR"; pwd -P)
      # GSH_EXEC_DIR shouldn't be empty but consist at least of a "." (as per POSIX).
      # just in case
      GSH_EXEC_DIR=${GSH_EXEC_DIR:-.}

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


if [ "$GSH_EXTRACT" = "true" ]
then
    tail -n+"$NB_LINES" "$GSH_EXEC_DIR/$GSH_EXEC_FILE" > "$GSH_EXEC_DIR/${GSH_EXEC_FILE%.*}.tgz"
    echo "Archive saved in $GSH_EXEC_DIR/${GSH_EXEC_FILE%.*}.tgz"
    exit 0
fi


GSH_ROOT=$GSH_EXEC_DIR/$GSH_NAME
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
      echo "Error: I don't want to remove directoryy $GSH_ROOT!" >&2
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
$current_shell "$GSH_ROOT/start.sh" -C "$@"

# zsh doesn't receive SIGCHLD but seems to always continue, even in the case of
# SIGHUP. We thus call _remove_root explicitly.
_remove_root $?

##START_OF_GAMESHELL_ARCHIVE##
