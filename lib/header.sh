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


NB_LINES=$(awk '/^##START_OF_GAMESHELL_ARCHIVE##/ {print NR + 1; exit 0; }' "$GSH_EXEC_FILE")

for arg in "$@"
do
  if [ "$arg" = "-X" ]
  then
    tail -n+"$NB_LINES" "$GSH_EXEC_FILE" > "${GSH_EXEC_FILE%.*}.tgz"
    echo "Archive saved in ${GSH_EXEC_FILE%.*}.tgz"
    exit 0
  elif [ "$arg" = "-K" ]
  then
    KEEP_DIR="true"
  fi
done


# remove extension (if present)
GSH_NAME=${GSH_EXEC_FILE%.*}
# remove "-save" suffix (if present)
GSH_NAME=${GSH_NAME%-save}
GSH_NAME=$(basename "$GSH_NAME")

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

tail -n+"$NB_LINES" "$GSH_EXEC_FILE" > "$GSH_ROOT/gameshell.tgz"
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
