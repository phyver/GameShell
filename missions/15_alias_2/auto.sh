mkdir -p "$GASH_CHEST"
alias "$(gettext "journal")"="nano $GASH_CHEST/$(gettext "journal").txt"
gash check
