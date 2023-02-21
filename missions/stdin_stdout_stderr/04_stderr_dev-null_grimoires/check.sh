#!/usr/bin/env sh

_mission_check() (
    pc=$(. fc-lnr.sh | head -n 1)

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
