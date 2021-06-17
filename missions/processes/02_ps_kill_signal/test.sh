#!/bin/sh

my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill 2> /dev/null
my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 2> /dev/null
gsh assert check true

my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill -9 2> /dev/null
gsh assert check false

my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill 2> /dev/null
my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | xargs kill 2> /dev/null
my_ps | awk -v spell="$(gettext "spell")" '$0 ~ spell {print $1}' | head -n2 | xargs kill -9 2> /dev/null
gsh assert check false
