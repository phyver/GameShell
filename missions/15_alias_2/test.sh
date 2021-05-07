alias "$(gettext "journal")"="nano $GSH_CHEST/$(gettext "journal").txt"
gsh assert check true
unalias "$(gettext "journal")"

cd $GSH_CHEST
alias "$(gettext "journal")"="nano $(gettext "journal").txt"
gsh assert check false

cd
alias "$(gettext "journal")"="nano ${GSH_CHEST#$GSH_BASE/}/$(gettext "journal").txt"
gsh assert check false
