#!/bin/sh

COLUMNS=512 ps -cA | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 2>/dev/null
gsh assert check true

gsh assert check false
