#!/bin/bash

export GSH_BASE="$(dirname "$0")/.."
source $GSH_BASE/lib/os_aliases.sh
GSH_BASE=$(REALPATH "$GSH_BASE")
source $GSH_BASE/lib/make_index.sh

export GSH_MISSIONS="$GSH_BASE/missions"

make_index "$@"
