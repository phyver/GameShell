#!/bin/bash

export GASH_BASE="$(dirname "$0")/.."
source $GASH_BASE/lib/os_aliases.sh
GASH_BASE=$(REALPATH "$GASH_BASE")
source $GASH_BASE/lib/make_index.sh

export GASH_MISSIONS="$GASH_BASE/missions"

make_index "$@"
