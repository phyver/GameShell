#!/usr/bin/env sh

_mission_check() (
    pc=$(. fc-lnr.sh | head -n 1)

    echo "$pc" | grep -q 'gsh\s\s*check' && return 1

    if ! echo "$pc" | grep -q 'grep'
    then
        echo "$(gettext "Your previous command doesn't use the 'grep' command...")"
        return 1
    fi

    temp_file1=$(mktemp)
    temp_file2=$(mktemp)
    eval "$pc | sort" 1>"$temp_file1" 2>"$temp_file2"

    if ! cmp -s "$GSH_TMP/list_grimoires_GSH" "$temp_file1"
    then
      rm -f "$temp_file1" "$temp_file2"
      return 1
    fi

    if [ -s "$temp_file2" ]
    then
      echo "$(gettext "Your command shouldn't generate error messages...")"
      rm -f "$temp_file1" "$temp_file2"
      return 1
    fi

    rm -f "$temp_file1" "$temp_file2"
    return 0
)

_mission_check
