#!/bin/sh

alias "$(gettext "journal")"="nano \"$GSH_CHEST/$(gettext "journal").txt\""
gsh assert check true
unalias "$(gettext "journal")" 2>/dev/null

cd "$GSH_CHEST"
alias "$(gettext "journal")"="nano '$(gettext "journal").txt\""
gsh assert check false

cd
alias "$(gettext "journal")"="nano \"${GSH_CHEST#$GSH_ROOT/}/$(gettext "journal").txt\""
gsh assert check false

EDITOR=vim
alias "$(gettext "journal")"="vim \"$GSH_CHEST/$(gettext "journal").txt\""
gsh assert check true

EDITOR=vim
alias "$(gettext "journal")"="\$EDITOR \"$GSH_CHEST/$(gettext "journal").txt\""
gsh assert check true

EDITOR=vim
alias "$(gettext "journal")"="nano \"$GSH_CHEST/$(gettext "journal").txt\""
gsh assert check false

EDITOR=nano
alias "$(gettext "journal")"="nano \"$GSH_CHEST/$(gettext "journal").txt\""
gsh assert check true
