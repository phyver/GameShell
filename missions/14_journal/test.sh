rm "$GASH_CHEST/$(gettext "journal").txt"
gash assert check false

touch "$GASH_CHEST/$(gettext "journal").txt"
gash assert check false

echo "TEST" > "$GASH_CHEST/$(gettext "journal").txt"
gash assert check true

rm "$GASH_CHEST/$(gettext "journal").txt"
