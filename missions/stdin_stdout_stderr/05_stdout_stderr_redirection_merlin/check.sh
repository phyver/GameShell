#!/bin/bash

_mission_check() {
  local secret=$(cat "$GSH_VAR/secret_key")

  local r
  read -erp "$(gettext "What is the secret key?") " r

  if [ "$secret" != "$r" ]
  then
    echo "$(gettext "That's not the correct key!")"
    return 1
  fi

  if [ -t 0 ]
  then
    # got input interactively from a tty
    echo "$(gettext "That's correct, but you need to use a redirection to complete this mission!")"
    return 1
  fi
  return 0
}

_mission_check
