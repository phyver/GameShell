mkdir -p "$GASH_CHEST"
echo "I'll be back." > "$GASH_CHEST/$(gettext "journal").txt"
gash check
