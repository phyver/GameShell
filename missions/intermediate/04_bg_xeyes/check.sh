#!/usr/bin/env sh

# fc in specified in POSIX, but debian's sh doesn't implement it!

_mission_check() {
  if ! (. fc-lnr.sh | head -n 4 | grep -qx "[[:blank:]]*xeyes[[:blank:]]*")
  then
    echo "$(gettext "Have you run the 'xeyes' command directly?")"
    ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null
    return 1
  fi

  # NOTE, there is a strange bug(?) in zsh that prevent piping the output of
  # jobs from inside a shell script. We need this feature when running tests
  # using "zsh -c ..."
  # cf https://www.zsh.org/mla/workers/2010/msg00907.html
  # Instead of "jobs | grep xeyes", we use a temporary file.
  # (We could probably use process redirection "grep xeyes <(jobs)" as well.)
  tmp_file=$(mktemp)
  LANGUAGE= LC_ALL=C jobs >"$tmp_file"
  if ! grep xeyes "$tmp_file" | grep -qi running
    # beware: bash appends a "&" for running background jobs, but not zsh
  then
    echo "$(gettext "There is no 'xeyes' process running.")"
    ps -e | awk '/xeyes/ {print $1}' | xargs kill -9 2> /dev/null
    false
  else
    true
  fi
}

_mission_check


