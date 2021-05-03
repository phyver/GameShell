#!/bin/bash


if [ -f "$GASH_MISSION_DATA" ]
then
    while read file
    do
        rm "$file"
    done < "$GASH_MISSION_DATA/list_grimoires_RO"
fi
rm -f "$GASH_MISSION_DATA/list_grimoires_RO"
rm -f "$GASH_MISSION_DATA/list_grimoires_PQ"
