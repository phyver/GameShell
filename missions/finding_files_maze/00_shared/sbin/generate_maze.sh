#!/usr/bin/env sh

DIR=$1
DEPTH=$2
WIDTH=$3
nb_path=$4
stone=$5

awk -v DIR="$DIR" \
    -v DEPTH="$DEPTH" \
    -v WIDTH="$WIDTH" \
    -v nb_random_path="$nb_path" \
    -v leaf_content="$stone" \
    -v seed_file="$GSH_CONFIG/PRNG_seed" \
    -f "$MISSION_DIR/sbin/generate_maze.awk"
