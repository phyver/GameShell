#!/usr/bin/env bash


if [ -f "$GSH_VAR/list_grimoires_RO" ]
then
    while read file
    do
        rm "$file"
    done < "$GSH_VAR/list_grimoires_RO"
fi
rm -f "$GSH_VAR/list_grimoires_RO"
rm -f "$GSH_VAR/list_grimoires_PQ"
