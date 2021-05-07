#!/bin/bash


if [ -f "$GSH_MISSION_DATA" ]
then
    while read file
    do
        rm "$file"
    done < "$GSH_MISSION_DATA/list_grimoires_RO"
fi
rm -f "$GSH_MISSION_DATA/list_grimoires_RO"
rm -f "$GSH_MISSION_DATA/list_grimoires_PQ"
