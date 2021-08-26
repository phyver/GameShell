#!/bin/sh

my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill 2>/dev/null
sleep 1
my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 2>/dev/null
sleep 1
gsh check
