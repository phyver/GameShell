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


ORIGINAL_FILENAME="$0"
ORIGINAL_DIR=$(dirname "$0")

# ORIGINAL_DIR shouldn't be empty but consist at least of a "." (as per POSIX).
# just in case
ORIGINAL_DIR=${ORIGINAL_DIR:-.}


NB_LINES=$(awk '/^##START_OF_GAMESHELL_ARCHIVE##/ {print NR + 1; exit 0; }' "$ORIGINAL_FILENAME")

for arg in "$@"
do
  if [ "$arg" = "-X" ]
  then
    tail -n+"$NB_LINES" "$ORIGINAL_FILENAME" > "${ORIGINAL_FILENAME%.*}.tgz"
    echo "Archive saved in ${ORIGINAL_FILENAME%.*}.tgz"
    exit 0
  elif [ "$arg" = "-K" ]
  then
    KEEP_DIR="true"
  fi
done


# remove extension (if present)
GSH_NAME=${ORIGINAL_FILENAME%.*}
# remove "-save" suffix (if present)
GSH_NAME=${GSH_NAME%-save}
GSH_NAME=$(basename "$GSH_NAME")

GSH_ROOT=$ORIGINAL_DIR/$GSH_NAME
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

tail -n+"$NB_LINES" "$ORIGINAL_FILENAME" > "$GSH_ROOT/gameshell.tgz"
tar -zx -C "$GSH_ROOT" -f "$GSH_ROOT/gameshell.tgz"
rm "$GSH_ROOT/gameshell.tgz"

# the archive should extract into a directory, move everything to GSH_ROOT
TMP_ROOT=$(find "$GSH_ROOT" -maxdepth 1 -path "$GSH_ROOT/*" -type d | head -n1)
mv "$TMP_ROOT"/* "$GSH_ROOT"
mv "$TMP_ROOT"/.[!.]* "$GSH_ROOT" 2>/dev/null
rmdir "$TMP_ROOT"

###
# save function
_save() {
  trap - CHLD
  ret=$1

  tar -zcf "$GSH_ROOT.tgz" -C "$ORIGINAL_DIR" ./"$GSH_ROOT"
  ARCHIVE_OK=$?


  # get extension
  EXT=${ORIGINAL_FILENAME##*.}
  # remove extension
  ORIGINAL_FILENAME=${ORIGINAL_FILENAME%.*}
  # remove "-save" suffix (if present), and add it again, with the extension
  ORIGINAL_FILENAME=${ORIGINAL_FILENAME%-save}-save.$EXT

  cat "$GSH_ROOT/lib/header.sh" "$GSH_ROOT.tgz" > "$ORIGINAL_FILENAME"
  SAVE_OK=$?
  chmod +x "$ORIGINAL_FILENAME"

  # remove archive
  rm -f "$GSH_ROOT.tgz"

  if [ "$ARCHIVE_OK" -ne 0 ] || [ "$SAVE_OK" -ne 0 ]
  then
    echo
    echo "*******************************************************"
    echo "Error: save file might be incorrect, test it by running"
    echo "    $ $current_shell \"$ORIGINAL_FILENAME\""
    echo
    echo "If that works as expected, you can remove the \"$GSH_ROOT\" directory."
    echo
    KEEP_DIR="true"
  fi

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
# I want to run the _save command when the (only) child terminates
# In bash, I can trap SIGCHLD, but for some reason, we cannot trap SIGCHLD when
# the main process receives SIGHUP (for example when the terminal is closed),
# unless we trap SIGHUP as well. (Even an empty trap is OK.)
#
# This doesn't work for zsh, so I need to call _save explicitly. In the case of
# SIGHUP, the child is terminated and the main process continues normally, so
# that _save is indeed executed...

trap "" HUP SIGHUP
trap '_save $?' CHLD
$current_shell "$GSH_ROOT/start.sh" -C "$@"

# zsh doesn't receive SIGCHLD but seems to always continue, even in the case of
# SIGHUP. We thus call _save explicitly.
_save $?

##START_OF_GAMESHELL_ARCHIVE##
