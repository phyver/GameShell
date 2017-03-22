#!/bin/bash

$GASH_BIN/felix.sh &
disown
$GASH_BIN/gros_minet.sh &
disown

