#!/usr/bin/env sh

my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 2>/dev/null
sleep 1
gsh assert check true

gsh assert check false
