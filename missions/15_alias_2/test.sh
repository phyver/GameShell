alias "$(gettext "journal")"="nano $GASH_CHEST/$(gettext "journal").txt"
gash assert check true
unalias "$(gettext "journal")"

cd $GASH_CHEST
alias "$(gettext "journal")"="nano $(gettext "journal").txt"
gash assert check false

cd
alias "$(gettext "journal")"="nano ${GASH_CHEST#$GASH_BASE/}/$(gettext "journal").txt"
gash assert check false
