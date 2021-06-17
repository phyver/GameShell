#!/bin/sh


if [ -f "$GSH_TMP/list_grimoires_RO" ]
then
    while IFS= read file
    do
        rm "$file"
    done < "$GSH_TMP/list_grimoires_RO"
fi
unset file
rm -f "$GSH_TMP/list_grimoires_RO"
rm -f "$GSH_TMP/list_grimoires_GSH"
