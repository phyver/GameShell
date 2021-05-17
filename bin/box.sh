#!/usr/bin/env bash

box=$1
filename=$2

get_size() {
    awk '{w=w<length($0) ? length($0) : w;} END {printf("-v width=%d -v height=%d", w, NR);}'
}

size=$(get_size < "$filename")

awk -v box=$box $size -f "$(dirname "$0")/box-data.awk" -f "$(dirname "$0")/box.awk" < "$filename"
