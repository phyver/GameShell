rm "$GSH_CHEST/$(gettext "journal").txt"
gsh assert check false

touch "$GSH_CHEST/$(gettext "journal").txt"
gsh assert check false

echo "TEST" > "$GSH_CHEST/$(gettext "journal").txt"
gsh assert check true

rm "$GSH_CHEST/$(gettext "journal").txt"
