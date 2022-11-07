#!/usr/bin/env sh

[ -z "$GSH_ROOT" ] && echo "Error: GSH_ROOT undefined" && exit 1

### defining GSH directories

# first, resolve symbolic links in GSH_ROOT
GSH_ROOT=$(cd "$GSH_ROOT" && pwd -P)
export GSH_ROOT

# these directories should not be modified during a game
export GSH_LIB="$GSH_ROOT/lib"
export GSH_MISSIONS="$GSH_ROOT/missions"

# these directories should be erased when a new game is started, they only contain
# dynamic data
export GSH_HOME="$GSH_ROOT/World"
export GSH_CONFIG="$GSH_ROOT/.config"
export GSH_TMP="$GSH_ROOT/.tmp"
[ -d "$GSH_TMP" ] && export TMP_DIR=$GSH_TMP
export GSH_BIN="$GSH_ROOT/.bin"
export GSH_SBIN="$GSH_ROOT/.sbin"

export TEXTDOMAINDIR="$GSH_ROOT/locale"
export TEXTDOMAIN="gsh"

# putting $GSH_ROOT/bin first makes sure the local scripts are prefered over
# system commands (realpath, seq, etc.). This is useful for testing, but
# probably shouldn't be done for "stable" releases.
PATH="$GSH_ROOT/scripts":$PATH
# PATH=$PATH:"$GSH_ROOT/scripts"

