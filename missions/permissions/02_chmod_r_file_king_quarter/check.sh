#!/usr/bin/env bash

read -erp "$(gettext "What's the secret key to open the safe?") " key
real_key=$(cat "$GSH_VAR/key")

if [ "$key" = "$real_key" ]
then
    unset key real_key
    true
else
    echo "$(gettext "That's not the real key!")"
    unset key real_key
    false
fi
