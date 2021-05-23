#!/bin/bash

read -erp "$(gettext "What's the combination to open the King's safe?") " key
real_key=$(cat "$GSH_VAR/key")

if [ "$key" = "$real_key" ]
then
    unset key real_key
    true
else
    echo "$(gettext "That's not the real combination!")"
    unset key real_key
    false
fi
