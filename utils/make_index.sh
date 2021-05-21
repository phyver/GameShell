#!/usr/bin/env bash

export GSH_ROOT="$(dirname "$0")/.."
source $GSH_ROOT/lib/common.sh

export GSH_MISSIONS="$GSH_ROOT/missions"

make_index "$@"
