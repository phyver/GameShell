#!/usr/bin/env bash

secret=$(cat "$GSH_VAR/secret_key")

read -erp "$(gettext "What is the secret key?") " r

if [ "$secret" = "$r" ]
then
    unset secret r
    true
else
    unset secret r
    false
fi
