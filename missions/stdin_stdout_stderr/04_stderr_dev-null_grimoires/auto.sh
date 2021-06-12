#!/bin/bash

# ``history`` command is not in POSIX

cd "$(eval_gettext '$GSH_HOME/Castle/Main_building/Library/Merlin_s_office')"

# les commandes ne sont pas dans l'historique, il faut les y ajouter à la main !
history -s 'grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null'
history -s gsh check

# grep -il "gsh" "$(gettext "grimoire")"_* 2> /dev/null
gsh check

# macOS' version of bash is too old and we cannot delete ranges of commands in
# history
n=$(history | tail -n1 | awk '{print $1}')
history -d $((n-1))
history -d $((n-1))
unset n
