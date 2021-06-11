#!/bin/sh

_mission_check() (
    # TODO: for some unknown reason, redirecting the output of fc into another
    # command shifts the results: it then sees the "gsh check" command that
    # was used to run this function
    # I grep the previous command to avoid looping by re-running "gsh check"
    # recursively. Because of the previous remark, I need to look at the "-2"
    # command
    pc=$(fc -nl -1 -1)

    echo "$pc" | grep -q 'gsh\s\s*check' && return 1

    if ! echo "$pc" | grep -q 'grep'
    then
        echo "$(gettext "Your previous command doesn't use the 'grep' command...")"
        return 1
    fi

    temp_file=$(mktemp)
    eval "$pc" | sort >"$temp_file"
    if cmp -s "$GSH_TMP/list_grimoires_GSH" "$temp_file"
    then
      rm -f "$temp_file"
      return 0
    else
      rm -f "$temp_file"
      return 1
    fi
)

_mission_check
