#!/bin/bash


if [ -f "$GSH_VAR/list_grimoires_RO" ]
then
    while read file
    do
        rm "$file"
    done < "$GSH_VAR/list_grimoires_RO"
fi
unset file
rm -f "$GSH_VAR/list_grimoires_RO"
rm -f "$GSH_VAR/list_grimoires_PQ"
