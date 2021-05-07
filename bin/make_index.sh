#!/bin/bash

export GSH_ROOT="$(dirname "$0")/.."
source $GSH_ROOT/lib/os_aliases.sh
GSH_ROOT=$(REALPATH "$GSH_ROOT")
source $GSH_ROOT/lib/make_index.sh

export GSH_MISSIONS="$GSH_ROOT/missions"

make_index "$@"
