#!/bin/bash

# "local" is not in POSIX, and function cannot be in a subshell as it needs
# access to aliases defined in the main shell.

_mission_check() {
  # TODO: doesn't work if the alias string contains tab characters.
  # In that case, zsh outputs a "$C-string" like $'ls\t -A'
  #
  local cmd=$(alias la 2> /dev/null | cut -f2 -d"=" | tr -d "' \"\\t")
  if [ -z "$cmd" ]
  then
    echo "$(gettext "The alias 'la' doesn't exist...")"
    return 1
  elif ! la / >/dev/null 2>/dev/null
  then
    echo "$(gettext "The alias 'la' is invalid...")"
    return 1
  elif [ "$cmd" != 'ls-A' ]
  then
    echo "$(gettext "The alias 'la' doesn't run 'ls -A'...")"
    return 1
  else
    return 0
  fi
}

_mission_check
