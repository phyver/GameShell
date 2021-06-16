#!/bin/sh

[ -z "$GSH_ROOT" ] && echo "Error: GSH_ROOT undefined" && exit 1

### defining GSH directories

# first, resolve symbolic links in GSH_ROOT
GSH_ROOT=$(cd "$GSH_ROOT" && pwd -P)

# these directories should not be modified during a game
export GSH_LIB="$GSH_ROOT/lib"
export GSH_MISSIONS="$GSH_ROOT/missions"

# these directories should be erased when a new game is started, they only contain
# dynamic data
export GSH_HOME="$GSH_ROOT/World"
export GSH_CONFIG="$GSH_ROOT/.config"
export GSH_VAR="$GSH_ROOT/.var"
export GSH_BIN="$GSH_ROOT/.bin"
export GSH_SBIN="$GSH_ROOT/.sbin"

export TEXTDOMAINDIR="$GSH_ROOT/locale"
export TEXTDOMAIN="gsh"

# export the COLUMNS variable so the reflow script can get the terminal size
export COLUMNS

# PATH=$PATH:"$GSH_ROOT/bin"
PATH="$GSH_ROOT/bin":$PATH

### generate GameShell translation files
# NOTE: nullglob don't expand in POSIX sh and there is no shopt -s nullglob as in bash
if [ -n "$(find "$GSH_ROOT/i18n" -maxdepth 1 -name '*.po' | head -n1)" ]
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


### test some of the scripts
if ! sh "$GSH_ROOT/lib/bin_test.sh"
then
  echo "$(gettext "Error: a least one base function is not working properly.
Aborting!")"
  exit 1
fi
