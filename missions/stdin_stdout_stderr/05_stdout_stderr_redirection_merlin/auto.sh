#!/bin/sh

key=$(mktemp)
"$(eval_gettext '$GSH_HOME/Castle/Observatory')"/merlin 2>"$key"

gsh check <"$key"
rm -f "$key"

