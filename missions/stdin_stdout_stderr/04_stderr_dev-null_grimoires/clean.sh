#!/usr/bin/env sh


if [ -f "$GSH_TMP/list_grimoires-R" ]
then
    while IFS= read file
    do
        rm "$file"
    done < "$GSH_TMP/list_grimoires-R"
fi
unset file
rm -f "$GSH_TMP/list_grimoires-R"
rm -f "$GSH_TMP/list_grimoires_GSH"
